const fs = require('fs');
const path = require('path');

const TEXTILE_EXT = '.textile';
const targetDir = process.argv[2];

console.log(`Reading files from ${targetDir}`);

async function convert() {
    fs.readdir(targetDir, async (err, files) => {
        if (err) {
            console.error(err);
        } else {
            const textileFiles = files.filter(f => f.endsWith(TEXTILE_EXT));
            textileFiles
                .forEach(file => {
                    const input = path.join(targetDir, file);
                    fs.readFile(path.join(targetDir, file), (err, contents) => {
                        if (err) {
                            console.error(err);
                            return;
                        }
                        let updated = contents.toString();
                        // format links
                        updated = updated.replace(/"(.*?)":(\S+(?<![\.,\!]))/gmi, '[$1]($2)');
                        // format headings
                        for (let i = 1; i <= 6; i++) {
                            const reString = '(h'+i+'\\.\\s)';
                            const re = new RegExp(reString, 'gmi');
                            updated = updated.replace(re, '#'.repeat(i) + ' ');
                        }
                        // remove center align tags
                        updated = updated.replace(/p=\. /gmi, '');
                        // images with alt text
                        updated = updated.replace(/![^!\s\)\(\.,\?](.*)\((.*)\)!/gmi, '![$2]($1)');
                        // images without alt text
                        updated = updated.replace(/![^!\s\)\(\.,\?](.*)!/, '!($1)');

                        fs.writeFile(input, updated, (err) => {
                            if (err) {
                                console.error('error saving to ' + input, err);
                            }
                        });
                    });
                });            
        }
    });
}

convert();