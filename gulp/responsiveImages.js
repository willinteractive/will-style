//
// Generate responsive imageset based on bootstrap's grid

// Place images in /src folder and they will be exported to the /dist folder

// Example: gulp generate-responsive-images

import gulp from "gulp";

import sharpResponsive from "gulp-sharp-responsive";

import { deleteSync } from "del";

gulp.task('clear-responsive-images', function(done) {
    deleteSync(["dist/"]);
    done();
});

gulp.task("copy-svgs", function() {
    return gulp.src("src/**/*.svg")
        .pipe(gulp.dest("dist"));
});

gulp.task("generate-responsive-images", gulp.series('clear-responsive-images', 'copy-svgs', function() {
    return gulp.src("src/**/*.{gif,jpg,png}")
        .pipe(sharpResponsive({
            formats: [

                // Original File

                {
                    width: 540,
                    rename: ({}, {
                        suffix: "-540"
                    }),
                    sharp: { failOnError: false, density: 72 },
                    jpegOptions: {
                        quality: 70, progressive: false
                    },
                    pngOptions: {
                        quality: 70, progressive: false
                    },
                    webpOptions: {
                        quality: 70, progressive: false
                    }
                },
                {
                    width: 768,
                    rename: ({}, {
                        suffix: "-768"
                    }),
                    sharp: { failOnError: false, density: 72 },
                    jpegOptions: {
                        quality: 80, progressive: false
                    },
                    pngOptions: {
                        quality: 80, progressive: false
                    },
                    webpOptions: {
                        quality: 80, progressive: false
                    }
                },
                {
                    width: 960,
                    rename: ({}, {
                        suffix: "-960"
                    }),
                    sharp: { failOnError: false, density: 72 },
                    jpegOptions: {
                        quality: 80, progressive: false
                    },
                    pngOptions: {
                        quality: 80, progressive: false
                    },
                    webpOptions: {
                        quality: 80, progressive: false
                    }
                },
                {
                    width: 1140,
                    rename: ({}, {
                        suffix: "-1140"
                    }),
                    sharp: { failOnError: false, density: 72 },
                    jpegOptions: {
                        quality: 80, progressive: false
                    },
                    pngOptions: {
                        quality: 80, progressive: false
                    },
                    webpOptions: {
                        quality: 80, progressive: false
                    }
                },
                {
                    width: 1320,
                    rename: ({}, {
                        suffix: "-1320"
                    }),
                    sharp: { failOnError: false, density: 72 },
                    jpegOptions: {
                        quality: 80, progressive: false
                    },
                    pngOptions: {
                        quality: 80, progressive: false
                    },
                    webpOptions: {
                        quality: 80, progressive: false
                    }
                },
                {
                    width: 1920,
                    sharp: { failOnError: false, density: 72 },
                    jpegOptions: {
                        quality: 80, progressive: false
                    },
                    pngOptions: {
                        quality: 80, progressive: false
                    },
                    webpOptions: {
                        quality: 80, progressive: false
                    }
                },

                 // WebP File

                 {
                    width: 540,
                    rename: ({}, {
                        suffix: "-540"
                    }),
                    format: "webp",
                    sharp: { failOnError: false, density: 72 },
                    jpegOptions: {
                        quality: 70, progressive: false
                    },
                    pngOptions: {
                        quality: 70, progressive: false
                    },
                    webpOptions: {
                        quality: 70, progressive: false
                    }
                },
                {
                    width: 768,
                    rename: ({}, {
                        suffix: "-768"
                    }),
                    format: "webp",
                    sharp: { failOnError: false, density: 72 },
                    jpegOptions: {
                        quality: 80, progressive: false
                    },
                    pngOptions: {
                        quality: 80, progressive: false
                    },
                    webpOptions: {
                        quality: 80, progressive: false
                    }
                },
                {
                    width: 960,
                    rename: ({}, {
                        suffix: "-960"
                    }),
                    format: "webp",
                    sharp: { failOnError: false, density: 72 },
                    jpegOptions: {
                        quality: 80, progressive: false
                    },
                    pngOptions: {
                        quality: 80, progressive: false
                    },
                    webpOptions: {
                        quality: 80, progressive: false
                    }
                },
                {
                    width: 1140,
                    rename: ({}, {
                        suffix: "-1140"
                    }),
                    format: "webp",
                    sharp: { failOnError: false, density: 72 },
                    jpegOptions: {
                        quality: 80, progressive: false
                    },
                    pngOptions: {
                        quality: 80, progressive: false
                    },
                    webpOptions: {
                        quality: 80, progressive: false
                    }
                },
                {
                    width: 1320,
                    rename: ({}, {
                        suffix: "-1320"
                    }),
                    format: "webp",
                    sharp: { failOnError: false, density: 72 },
                    jpegOptions: {
                        quality: 80, progressive: false
                    },
                    pngOptions: {
                        quality: 80, progressive: false
                    },
                    webpOptions: {
                        quality: 80, progressive: false
                    }
                },
                {
                    width: 1920,
                    format: "webp",
                    sharp: { failOnError: false, density: 72 },
                    jpegOptions: {
                        quality: 80, progressive: false
                    },
                    pngOptions: {
                        quality: 80, progressive: false
                    },
                    webpOptions: {
                        quality: 80, progressive: false
                    }
                }
            ]
        }))
        .pipe(gulp.dest("dist"));
}));
