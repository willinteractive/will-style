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
        // The gem's shipped browser JS: real ES modules as of item C2
        // (docs/MIGRATION.md) -- window.WillStyle only appears now as a
        // documented compatibility shim in core/settings.js, core/events.js,
        // and forms/expanding-textareas.js.
        files: ["app/javascript/**/*.js"],
        languageOptions: {
            ecmaVersion: 2021,
            sourceType: "module",
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
