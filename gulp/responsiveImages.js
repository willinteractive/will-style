//
// Generate responsive imageset based on bootstrap's grid

// Place images in /src folder and they will be exported to the /dist folder

// Example: gulp generate-responsive-images

import gulp from "gulp";
import fg from "fast-glob";
import sharp from "sharp";
import path from "node:path";
import fs from "node:fs/promises";

import { deleteSync } from "del";

const BREAKPOINTS = [
    { width: 540, quality: 70 },
    { width: 768, quality: 80 },
    { width: 960, quality: 80 },
    { width: 1140, quality: 80 },
    { width: 1320, quality: 80 },
    { width: 1920, quality: 80 }
];

async function writeVariant(inputPath, outputPath, width, quality, format) {
    let image = sharp(inputPath, { failOnError: false }).resize({ width });

    if (format === "webp") {
        image = image.webp({ quality, progressive: false });
    } else if (path.extname(outputPath).toLowerCase() === ".png") {
        image = image.png({ quality, progressive: false });
    } else {
        image = image.jpeg({ quality, progressive: false });
    }

    await fs.mkdir(path.dirname(outputPath), { recursive: true });
    await image.toFile(outputPath);
}

gulp.task('clear-responsive-images', function(done) {
    deleteSync(["dist/"]);
    done();
});

gulp.task("copy-svgs", function() {
    return gulp.src("src/**/*.svg")
        .pipe(gulp.dest("dist"));
});

gulp.task("generate-responsive-images", gulp.series('clear-responsive-images', 'copy-svgs', async function() {
    const sourceFiles = await fg("src/**/*.{gif,jpg,png}");

    for (const sourcePath of sourceFiles) {
        const relativePath = path.relative("src", sourcePath);
        const { dir, name, ext } = path.parse(relativePath);

        for (const { width, quality } of BREAKPOINTS) {
            // The largest breakpoint (1920) matches the original gulp-sharp-responsive
            // rename config, which left it unsuffixed — every other width gets "-{width}".
            const suffix = width === 1920 ? "" : `-${width}`;
            const originalOut = path.join("dist", dir, `${name}${suffix}${ext}`);
            const webpOut = path.join("dist", dir, `${name}${suffix}.webp`);

            await writeVariant(sourcePath, originalOut, width, quality, "original");
            await writeVariant(sourcePath, webpOut, width, quality, "webp");
        }
    }
}));
