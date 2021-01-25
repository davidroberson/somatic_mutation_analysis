class: CommandLineTool
cwlVersion: v1.1
label: oncoplot
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: DockerRequirement
  dockerPull: cgc-images.sbgenomics.com/david.roberson/maftools:210125
- class: InitialWorkDirRequirement
  listing:
  - entryname: oncoplot.R
    writable: false
    entry: |-
      require(maftools)

      source("cwl_inputs.R")

      maf = readRDS(maf_object_path)

      png('oncoplot.png', width = 1280, height = 800, pointsize=20)

      oncoplot(maf = maf, top = 15, fontSize = 1,
               genes = getGeneSummary(maf)$Hugo_Symbol[1:20])

      dev.off()
  - entryname: cwl_inputs.R
    writable: false
    entry: maf_object_path = "$(inputs.maf_object.path)"
- class: InlineJavascriptRequirement
  expressionLib:
  - |2-

    var setMetadata = function(file, metadata) {
        if (!('metadata' in file)) {
            file['metadata'] = {}
        }
        for (var key in metadata) {
            file['metadata'][key] = metadata[key];
        }
        return file
    };
    var inheritMetadata = function(o1, o2) {
        var commonMetadata = {};
        if (!o2) {
            return o1;
        };
        if (!Array.isArray(o2)) {
            o2 = [o2]
        }
        for (var i = 0; i < o2.length; i++) {
            var example = o2[i]['metadata'];
            for (var key in example) {
                if (i == 0)
                    commonMetadata[key] = example[key];
                else {
                    if (!(commonMetadata[key] == example[key])) {
                        delete commonMetadata[key]
                    }
                }
            }
            for (var key in commonMetadata) {
                if (!(key in example)) {
                    delete commonMetadata[key]
                }
            }
        }
        if (!Array.isArray(o1)) {
            o1 = setMetadata(o1, commonMetadata)
            if (o1.secondaryFiles) {
                o1.secondaryFiles = inheritMetadata(o1.secondaryFiles, o2)
            }
        } else {
            for (var i = 0; i < o1.length; i++) {
                o1[i] = setMetadata(o1[i], commonMetadata)
                if (o1[i].secondaryFiles) {
                    o1[i].secondaryFiles = inheritMetadata(o1[i].secondaryFiles, o2)
                }
            }
        }
        return o1;
    };

inputs:
- id: maf_object
  type: File?

outputs:
- id: oncoplot
  type: File?
  outputBinding:
    glob: '*.png'
    outputEval: $(inheritMetadata(self, inputs.maf_object))

baseCommand:
- Rscript oncoplot.R

hints:
- class: sbg:SaveLogs
  value: '*.R'
id: david.roberson/maftools-demo/oncoplot/1
sbg:appVersion:
- v1.1
sbg:content_hash: a855a691bdea4e8d15cfdaebb7e82d9ef88901b1f8baf5be7638a1f8eadbf0192
sbg:contributors:
- david.roberson
sbg:createdBy: david.roberson
sbg:createdOn: 1611588611
sbg:id: david.roberson/maftools-demo/oncoplot/1
sbg:image_url:
sbg:latestRevision: 1
sbg:modifiedBy: david.roberson
sbg:modifiedOn: 1611588973
sbg:project: david.roberson/maftools-demo
sbg:projectName: maftools demo
sbg:publisher: sbg
sbg:revision: 1
sbg:revisionNotes: ''
sbg:revisionsInfo:
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1611588611
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1611588973
  sbg:revision: 1
  sbg:revisionNotes: ''
sbg:sbgMaintained: false
sbg:validationErrors: []
