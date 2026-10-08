#!/usr/bin/env python3
"""Validate the repository's closed JSON contracts and cross references.

Standard library only; deliberately implements only the keywords used here.
No simulation or economic/physical correctness is implied by a successful run.
"""
import argparse
from collections import Counter
import json
import math
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
KEYWORDS = {'$schema','title','description','type','properties','required',
            'additionalProperties','items','minItems','minimum','maximum',
            'exclusiveMinimum','enum','const','pattern'}
FOLDERS = {'items':'item','recipes':'recipe','stations':'station',
           'knowledge':'knowledge','environment':'environment','workflows':'workflow',
           'crops':'crop','scenarios':'scenario'}

def schema_errors(schema, where='$schema'):
    errors=[f'{where}: unsupported schema keyword {k}' for k in schema if k not in KEYWORDS]
    for k,v in schema.get('properties',{}).items():
        errors.extend(schema_errors(v,where+'.'+k))
    if 'items' in schema:errors.extend(schema_errors(schema['items'],where+'[]'))
    return errors

def matches(value,typ):
    return {'object':lambda:isinstance(value,dict),
            'array':lambda:isinstance(value,list),
            'string':lambda:isinstance(value,str),
            'number':lambda:isinstance(value,(int,float)) and not isinstance(value,bool),
            'integer':lambda:isinstance(value,int) and not isinstance(value,bool),
            'boolean':lambda:isinstance(value,bool),'null':lambda:value is None}[typ]()

def check(value,schema,where='$'):
    errors=[]
    types=schema.get('type')
    if types:
        types=[types] if isinstance(types,str) else types
        if not any(matches(value,t) for t in types):return [f'{where}: expected {types}']
    if 'const' in schema and (value != schema['const'] or type(value) != type(schema['const'])):
        errors.append(f'{where}: expected constant {schema["const"]!r}')
    if 'enum' in schema and value not in schema['enum']:errors.append(f'{where}: invalid enum value {value!r}')
    if isinstance(value,dict):
        for key in schema.get('required',[]):
            if key not in value:errors.append(f'{where}: missing {key}')
        props=schema.get('properties',{})
        for key,val in value.items():
            if key in props:errors.extend(check(val,props[key],where+'.'+key))
            elif schema.get('additionalProperties') is False:errors.append(f'{where}: unknown field {key}')
    if isinstance(value,list):
        if len(value)<schema.get('minItems',0):errors.append(f'{where}: too few items')
        for i,val in enumerate(value):errors.extend(check(val,schema.get('items',{}),f'{where}[{i}]'))
    if isinstance(value,(int,float)) and not isinstance(value,bool):
        if not math.isfinite(value):errors.append(f'{where}: non-finite number')
        for key,valid in [('minimum',lambda n:value>=n),('maximum',lambda n:value<=n),('exclusiveMinimum',lambda n:value>n)]:
            if key in schema and not valid(schema[key]):errors.append(f'{where}: violates {key} {schema[key]}')
    if isinstance(value,str) and 'pattern' in schema and re.search(schema['pattern'],value) is None:
        errors.append(f'{where}: invalid identifier {value!r}')
    return errors

def read_json(path):
    def pairs(values):
        out={}
        for key,val in values:
            if key in out:raise ValueError(f'duplicate JSON key {key}')
            out[key]=val
        return out
    def bad_constant(value):raise ValueError('non-finite JSON number '+value)
    return json.loads(path.read_text(encoding='utf-8'),object_pairs_hook=pairs,parse_constant=bad_constant)

def validate(root=ROOT):
    root=Path(root); errors=[]; records={}; counts=Counter(); documents=[]
    schemas={}
    for path in sorted((root/'schemas').glob('*.schema.json')):
        try:
            schema=read_json(path); errors.extend(schema_errors(schema,str(path)));schemas[path.name.split('.')[0]]=schema
        except (ValueError,OSError) as exc:errors.append(f'{path}: {exc}')
    for path in sorted((root/'content/core').rglob('*.json')):
        rel=path.relative_to(root/'content/core')
        kind=FOLDERS.get(rel.parts[0]) if len(rel.parts)>1 else {'pack.json':'pack','operations.json':'operations'}.get(rel.name)
        if kind not in schemas:
            errors.append(f'{rel}: unknown content type or missing schema');continue
        try:data=read_json(path)
        except (ValueError,OSError) as exc:errors.append(f'{rel}: {exc}');continue
        local=check(data,schemas[kind],str(rel));errors.extend(local)
        if local:continue
        counts[kind]+=1;documents.append((kind,data,str(rel)))
        if 'id' in data:
            if data['id'] in records:errors.append(f'{rel}: duplicate ID {data["id"]}')
            records[data['id']]=data
    if errors:return errors,dict(counts),documents
    for required in ('item','recipe','knowledge','environment','station','workflow','crop','pack','operations','scenario'):
        if not counts[required]:errors.append(f'missing required content type: {required}')
    caps={c for kind,d,_ in documents if kind=='item' for c in d['capabilities']}
    operations=[x['id'] for kind,d,_ in documents if kind=='operations' for x in d['operations']]
    if len(operations)!=len(set(operations)):errors.append('duplicate operation ID')
    def exists(id,where):
        if id not in records:errors.append(f'{where}: unknown reference {id}')
    def quantities(aa,where):
        ids=[]
        for a in aa:
            exists(a['item_id'],where);ids.append(a['item_id'])
            target=records.get(a['item_id'],{})
            if target.get('unit')=='piece' and a['quantity']%1:errors.append(f'{where}: fractional piece quantity')
            if abs(a['quantity']*1000-round(a['quantity']*1000))>1e-8:errors.append(f'{where}: exceeds quantity precision')
        if len(ids)!=len(set(ids)):errors.append(f'{where}: duplicate item amount')
    for kind,d,where in documents:
        if kind=='recipe':
            exists(d['station_id'],where);exists(d['knowledge_id'],where)
            for key in ('inputs','outputs'):quantities(d[key],where+'.'+key)
            for tool in d['tools']:
                if tool['capability'] not in caps:errors.append(f'{where}: unknown capability {tool["capability"]}')
            phase_ids=[]
            for p in d['phases']:
                exists(p['environment_profile_id'],where);phase_ids.append(p['id'])
                if p['on_condition_failure']=='pause' and 'max_blocked_game_minutes' not in p:errors.append(f'{where}: pause requires max blocked duration')
            if len(phase_ids)!=len(set(phase_ids)):errors.append(f'{where}: duplicate phase ID')
        elif kind=='workflow':
            for rid in d['recipe_ids']:exists(rid,where)
            for step in d['steps']:
                if step['operation_id'] not in operations:errors.append(f'{where}: unknown operation {step["operation_id"]}')
            if len({s['id'] for s in d['steps']})!=len(d['steps']):errors.append(f'{where}: duplicate step ID')
        elif kind=='crop':
            for key in ('seed_item_id','harvest_item_id'):
                exists(d[key],where)
                if records.get(d[key],{}).get('unit')!='kg':errors.append(f'{where}: crop quantities require kg items')
        elif kind=='scenario':
            quantities(d['inventory'],where)
            for id in d['known_recipes']+d['stations']:exists(id,where)
        elif kind=='environment':
            limits=d['limits']
            if limits.get('temperature_c_min',float('-inf'))>limits.get('temperature_c_max',float('inf')):errors.append(f'{where}: reversed temperature range')
        elif kind=='item' and d['capabilities'] and d['stackable']:errors.append(f'{where}: tools must be non-stackable')
    # Optimistic supply closure: imports/knowledge/stations are assumed available.
    # It catches broken chains, but is not proof of economic feasibility.
    available={d['id'] for k,d,_ in documents if k=='item' and d['external_source']}
    for k,d,_ in documents:
        if k=='scenario':available.update(a['item_id'] for a in d['inventory'])
    pending=[d for k,d,_ in documents if k=='recipe']
    while pending:
        can_caps={c for id in available for c in records.get(id,{}).get('capabilities',[])}
        ready=[r for r in pending if all(a['item_id'] in available for a in r['inputs']) and all(t['capability'] in can_caps for t in r['tools'])]
        if not ready:break
        for r in ready:
            available.update(a['item_id'] for a in r['outputs']);pending.remove(r)
    for r in pending:errors.append(f'{r["id"]}: no supply path from declared sources/scenario (including tools)')
    return errors,dict(counts),documents

def catalog(root,documents):
    items={d['id']:d for k,d,_ in documents if k=='item'}
    recipes=[d for k,d,_ in documents if k=='recipe']
    fmt=lambda aa:', '.join(f"{a['quantity']:g} {items[a['item_id']]['unit']} {items[a['item_id']]['name_de']}" for a in aa)
    lines=['# Rezeptkatalog','',f'{len(recipes)} Definitionen; alle definiert, nicht im Spiel implementiert. Mengen und Zeiten sind Balancingentwürfe.','', '| ID | Verfahren | Eingaben → Ergebnisse | Arbeit / passiv (Spielminuten) | Arbeitsplatz |','|---|---|---|---:|---|']
    for r in recipes:
        active=sum(p['duration_game_minutes'] for p in r['phases'] if p['mode']=='active')
        passive=sum(p['duration_game_minutes'] for p in r['phases'] if p['mode']=='passive')
        lines.append(f"| `{r['id']}` | {r['name_de']} | {fmt(r['inputs'])} → {fmt(r['outputs'])} | {active:g} / {passive:g} | {r['station_id']} |")
    (Path(root)/'docs/content/recipe-catalog.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root',type=Path,default=ROOT)
    parser.add_argument('--catalog',action='store_true',help='Regenerate the Markdown catalog after successful validation')
    args=parser.parse_args();errors,counts,documents=validate(args.root)
    if errors:
        for error in errors:print('ERROR:',error,file=sys.stderr)
        return 1
    if args.catalog:catalog(args.root,documents)
    print('PASS — content structure, references and optimistic supply closure')
    print(json.dumps(counts,ensure_ascii=False,sort_keys=True))
    print('NOT TESTED: gameplay, resource/energy balance, save/load, simulation performance.')
    return 0

if __name__=='__main__':sys.exit(main())
