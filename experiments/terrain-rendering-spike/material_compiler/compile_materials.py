#!/usr/bin/env python3
"""Deterministic image-to-material compiler. Requires Pillow. No generative fills.

Usage:
 python compile_materials.py --grass grass_1024.png --soil soil_1024.png --out assets
"""
import argparse
import hashlib
import json
from pathlib import Path
from PIL import Image, ImageChops, ImageStat

def rgb(path):
    image = Image.open(path).convert("RGB")
    if image.width != image.height or image.width < 512:
        raise ValueError(f"{path}: expected square source >=512px; got {image.size}")
    return image

def seamless(source, width=256):
    # Periodic synthesis from one source using offset-and-crossfade.
    # This can blur boundary detail; preserve original alongside for comparison.
    # Sample central square to avoid illustration-style framing at edges.
    w = min(source.size)
    region = source.crop(((source.width-w)//2,(source.height-w)//2,
                          (source.width+w)//2,(source.height+w)//2))
    patch = region.resize((width,width),Image.Resampling.NEAREST)
    # Periodic blend with flipped border partners, limited to 12.5% width.
    p = patch.load()
    src = patch.copy().load()
    b = width//8
    for y in range(width):
        for x in range(width):
            xs = x if x < width//2 else width-1-x
            ys = y if y < width//2 else width-1-y
            wx = max(0.0,1.0-xs/b)
            wy = max(0.0,1.0-ys/b)
            if wx or wy:
                q = src[x,y]
                if wx:
                    opposite = src[(x+width//2)%width,y]
                    q = tuple(round((1-wx*0.5)*a+wx*0.5*c) for a,c in zip(q,opposite))
                if wy:
                    opposite = src[x,(y+width//2)%width]
                    q = tuple(round((1-wy*0.5)*a+wy*0.5*c) for a,c in zip(q,opposite))
                p[x,y] = q
    # Force exact periodic equality along the two edges.
    for y in range(width):
        a,bp=p[0,y],p[width-1,y]
        c=tuple((i+j)//2 for i,j in zip(a,bp))
        p[0,y]=p[width-1,y]=c
    for x in range(width):
        a,bp=p[x,0],p[x,width-1]
        c=tuple((i+j)//2 for i,j in zip(a,bp))
        p[x,0]=p[x,width-1]=c
    return patch

def compile_one(label,path,out,meters):
    image=rgb(path)
    raw=Path(path).read_bytes()
    # Baseline tile is deliberately just nearest-downsampled; no claim seamless.
    base=seamless(image)
    base.save(out/f"{label}.png")
    # 2x2 and 4x4 diagnostic repeats expose repetition and edge seams.
    for n in (2,4):
        sheet=Image.new("RGB",(256*n,256*n))
        for j in range(n):
            for i in range(n):
                sheet.paste(base,(256*i,256*j))
        sheet.save(out/f"{label}_repeat_{n}x{n}.png")
    # Edge discrepancy of the 256px output, not a perceptual seam score.
    a=ImageChops.difference(base.crop((0,0,1,256)),base.crop((255,0,256,256)))
    b=ImageChops.difference(base.crop((0,0,256,1)),base.crop((0,255,256,256)))
    return dict(source=str(path),sha256=hashlib.sha256(raw).hexdigest(),
                source_pixels=list(image.size),source_meters=meters,
                source_pixels_per_meter=image.width/meters,
                compiled_pixels=256,compiled_meters=meters,
                compiled_pixels_per_meter=256/meters,
                edge_mean_rgb={"left_right":ImageStat.Stat(a).mean,
                               "top_bottom":ImageStat.Stat(b).mean},
                note="Nearest downsample + periodic boundary fix; seam equality does not imply visually seamless texture.")

def main():
    p=argparse.ArgumentParser()
    p.add_argument("--grass",required=True)
    p.add_argument("--soil",required=True)
    p.add_argument("--out",type=Path,default=Path("compiled"))
    p.add_argument("--meters",type=float,default=8.0)
    args=p.parse_args()
    if args.meters<=0: p.error("--meters must be positive")
    args.out.mkdir(parents=True,exist_ok=True)
    result={"schema":1,"compiler":"baseline-v0.1","materials":{}}
    for name,path in (("grass",args.grass),("soil",args.soil)):
        result["materials"][name]=compile_one(name,path,args.out,args.meters)
    (args.out/"manifest.json").write_text(json.dumps(result,indent=2)+"\n",encoding="utf-8")
    print(args.out/"manifest.json")

if __name__=="__main__":
    main()
