# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = "zeus"
copyright = "2024, Hogarth Worldwide"
author = "Hogarth Worldwide"
release = "latest"

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    "sphinx.ext.autodoc",
    "sphinx.ext.napoleon",
    "sphinx.ext.viewcode",
    # "sphinxcontrib.httpdomain",
    "sphinx_immaterial",
]

templates_path = ["_templates"]
exclude_patterns = []


# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = "sphinx_immaterial"
html_static_path = ["_static"]

html_theme_options = {
    "features": [
        "navigation.expand",
        "navigation.sections",
        "navigation.instant",
    ],
    # "repo_url": "https://github.com/brechtm/rinohtype",
    # "repo_name": "rinohtype",
    # "repo_type": "github",
    # "edit_uri": "edit/master/doc",
    "palette": {
        "media": "(prefers-color-scheme: dark)",
        "scheme": "slate",
        "primary": "indigo",
        "accent": "yellow",
        "toggle": {
            "icon": "material/lightbulb",
            "name": "Switch to light mode",
        },
    },
    "toc_title_is_page_title": True,
    "version_dropdown": True,
    # 'version_json': '../im_versions.json',
}
