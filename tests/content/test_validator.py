import importlib.util
import json
from pathlib import Path
import shutil
import tempfile
import unittest

ROOT=Path(__file__).resolve().parents[2]
spec=importlib.util.spec_from_file_location('validator',ROOT/'tools/validate_content.py')
validator=importlib.util.module_from_spec(spec);spec.loader.exec_module(validator)

class ContentTests(unittest.TestCase):
    def setUp(self):
        self.temp=tempfile.TemporaryDirectory();self.root=Path(self.temp.name)
        for folder in ('content','schemas'):shutil.copytree(ROOT/folder,self.root/folder)
    def tearDown(self):self.temp.cleanup()
    def mutate(self,relative,fn):
        path=self.root/relative;data=json.loads(path.read_text());fn(data)
        path.write_text(json.dumps(data),encoding='utf-8')
    def errors(self):return '\n'.join(validator.validate(self.root)[0])
    def test_valid_baseline(self):self.assertEqual(self.errors(),'')
    def test_unknown_item_reference(self):
        self.mutate('content/core/recipes/food/boil_water.json',lambda d:d['inputs'][0].update(item_id='item.missing'))
        self.assertIn('unknown reference item.missing',self.errors())
    def test_duplicate_id(self):
        shutil.copyfile(self.root/'content/core/items/pot.json',self.root/'content/core/items/copy.json')
        self.assertIn('duplicate ID item.pot',self.errors())
    def test_negative_quantity(self):
        self.mutate('content/core/recipes/food/boil_water.json',lambda d:d['outputs'][0].update(quantity=-1))
        self.assertIn('exclusiveMinimum',self.errors())
    def test_unknown_field_not_silently_ignored(self):
        self.mutate('content/core/items/pot.json',lambda d:d.update(capcity=5))
        self.assertIn('unknown field capcity',self.errors())
    def test_fractional_tool(self):
        self.mutate('content/core/recipes/tools/select_hammerstone.json',lambda d:d['outputs'][0].update(quantity=0.5))
        self.assertIn('fractional piece',self.errors())
    def test_unknown_workflow_operation(self):
        self.mutate('content/core/workflows/trade.json',lambda d:d['steps'][0].update(operation_id='magic_trade'))
        self.assertIn('unknown operation magic_trade',self.errors())
    def test_pause_needs_timeout(self):
        self.mutate('content/core/recipes/pottery/dry_pot.json',lambda d:d['phases'][1].pop('max_blocked_game_minutes'))
        self.assertIn('pause requires',self.errors())
    def test_missing_source_breaks_supply_chain(self):
        self.mutate('content/core/items/iron_ore.json',lambda d:d.update(external_source=None))
        self.assertIn('recipe.smelt_bloom: no supply path',self.errors())
    def test_unknown_schema_keyword_rejected(self):
        self.mutate('schemas/item.schema.json',lambda d:d.update(unsupported=True))
        self.assertIn('unsupported schema keyword',self.errors())

if __name__=='__main__':unittest.main()
