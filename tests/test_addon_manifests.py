"""Check the full repository, as Supervisor recursively discovers manifests."""

import unittest
from pathlib import Path

import yaml


ROOT = Path(__file__).resolve().parents[1]


class AddonManifestTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.manifests = []
        for path in ROOT.rglob("config.*"):
            if path.suffix not in {".yaml", ".yml", ".json"}:
                continue
            data = yaml.safe_load(path.read_text(encoding="utf-8"))
            # Exclude application data such as frontend branding/config.json.
            if isinstance(data, dict) and "slug" in data and "arch" in data:
                cls.manifests.append((path.relative_to(ROOT), data))

    def test_unique_slugs(self):
        seen = {}
        for path, data in self.manifests:
            slug = data["slug"]
            self.assertNotIn(slug, seen, f"Duplicate {slug}: {seen.get(slug)} and {path}")
            seen[slug] = path

    def test_only_root_addons_are_discoverable(self):
        self.assertEqual(
            {path.as_posix() for path, _ in self.manifests},
            {"visual-mapper/config.yaml", "visual-mapper-beta/config.yaml"},
        )

    def test_each_local_build_has_a_dockerfile(self):
        for path, data in self.manifests:
            if not data.get("image"):
                self.assertTrue((ROOT / path.parent / "Dockerfile").is_file(), str(path))


if __name__ == "__main__":
    unittest.main()
