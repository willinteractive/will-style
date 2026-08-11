// Aggregate entry point pinned as "will_style" in config/importmap.rb.
// Same file set and load order as the old Sprockets manifest this replaced
// (vendor -> core -> features -> components -> forms is load-bearing: core
// establishes window.WillStyle before anything else reads it) -- now plain
// ESM side-effect imports instead of Sprockets `//= require` directives, so
// importmap-rails is the only loading path. Individual files still exist as
// global-namespace IIFEs (see docs/MIGRATION.md item C2 for converting those).

// -------- Vendor
import "will_style/vendor/growfield"

// -------- CORE
import "will_style/core/settings"
import "will_style/core/events"

// -------- FEATURES
import "will_style/features/image-loading"
import "will_style/features/animated-elements"
import "will_style/features/hiding-default-link-titles"
import "will_style/features/spannable-elements"
import "will_style/features/google-analytics"
import "will_style/features/image-backgrounds"
import "will_style/features/video-backgrounds"
import "will_style/features/focused-form-elements"
import "will_style/features/overlapped-elements"

// -------- COMPONENTS
import "will_style/components/dropdowns"
import "will_style/components/navbar"
import "will_style/components/pop-out"
import "will_style/components/modals"

// -------- FORMS
import "will_style/forms/required-inputs"
import "will_style/forms/expanding-textareas"
import "will_style/forms/file-sizes"
import "will_style/forms/url-formatting"
import "will_style/forms/selected-buttons"
