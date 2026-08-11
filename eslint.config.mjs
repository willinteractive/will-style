import js from "@eslint/js";
import globals from "globals";

export default [
    js.configs.recommended,
    {
        // Vendored third-party script — not ours to lint or rewrite.
        ignores: [
            "node_modules/**",
            "dist/**",
            "src/**",
            "coverage/**",
            "app/javascript/will_style/vendor/**"
        ]
    },
    {
        // The gem's shipped browser JS: plain IIFEs attached to a global
        // WillStyle namespace, not ES modules (see docs/MIGRATION.md item C2).
        files: ["app/javascript/**/*.js"],
        languageOptions: {
            ecmaVersion: 2021,
            sourceType: "script",
            globals: {
                ...globals.browser,
                WillStyle: "writable",
                growfield: "readonly"
            }
        },
        rules: {
            "no-unused-vars": ["warn", { args: "none" }],
            // Used deliberately as an inverted-condition no-op branch
            // (e.g. required-inputs.js's select2-skip check) rather than a bug.
            "no-empty": "off"
        }
    },
    {
        // The importmap entry point aggregating the behavior files below via
        // plain ESM side-effect imports (see app/javascript/will_style.js) --
        // real module syntax, unlike the IIFE files it imports.
        files: ["app/javascript/will_style.js"],
        languageOptions: {
            ecmaVersion: 2021,
            sourceType: "module"
        }
    },
    {
        // Local dev tooling: Node ESM.
        files: ["gulp/**/*.js"],
        languageOptions: {
            ecmaVersion: 2021,
            sourceType: "module",
            globals: globals.node
        }
    },
    {
        // Local dev tooling: Node CommonJS.
        files: ["gulpfile.js"],
        languageOptions: {
            ecmaVersion: 2021,
            sourceType: "commonjs",
            globals: globals.node
        }
    }
];
