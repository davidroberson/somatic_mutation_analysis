class: CommandLineTool
cwlVersion: v1.1
label: maftools_read_and_summary
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: DockerRequirement
  dockerPull: cgc-images.sbgenomics.com/david.roberson/maftools:210125
- class: InitialWorkDirRequirement
  listing:
  - entryname: read_and_summary.R
    writable: false
    entry: |-
      require(maftools)

      source("cwl_inputs.R")

      #read TCGA maf file
      #useAll could be a toggle
      maf = read.maf(maf = maf_full_path, useAll = F)

      saveRDS(maf, "maf.rds")

      #potmafSummary

      png('maf_summary.png', width = 1280, height = 800, pointsize=20)

      plotmafSummary(maf, rmOutlier = TRUE,
                     addStat = 'median', dashboard = TRUE,
                     titvRaw = FALSE)

      dev.off()
  - entryname: cwl_inputs.R
    writable: false
    entry: maf_full_path = "$(inputs.maf.path)"
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
- id: maf
  type: File?

outputs:
- id: summary_plot
  type: File?
  outputBinding:
    glob: '*.png'
    outputEval: $(inheritMetadata(self, inputs.maf))
- id: maf_object
  type: File?
  outputBinding:
    glob: '*.rds'
    outputEval: $(inheritMetadata(self, inputs.maf))

baseCommand:
- Rscript read_and_summary.R

hints:
- class: sbg:SaveLogs
  value: '*.R'
id: david.roberson/maftools-demo/maftools-read-and-summary/4
sbg:appVersion:
- v1.1
sbg:content_hash: a602af3a1485e8b9e12fe010b129d37455ba357bb86fda450b86d8f674cf55c1d
sbg:contributors:
- david.roberson
sbg:createdBy: david.roberson
sbg:createdOn: 1611587033
sbg:id: david.roberson/maftools-demo/maftools-read-and-summary/4
sbg:image_url:
sbg:latestRevision: 4
sbg:modifiedBy: david.roberson
sbg:modifiedOn: 1611588463
sbg:project: david.roberson/maftools-demo
sbg:projectName: maftools demo
sbg:publisher: sbg
sbg:revision: 4
sbg:revisionNotes: ''
sbg:revisionsInfo:
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1611587033
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1611587246
  sbg:revision: 1
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1611587837
  sbg:revision: 2
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1611588126
  sbg:revision: 3
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1611588463
  sbg:revision: 4
  sbg:revisionNotes: ''
sbg:sbgMaintained: false
sbg:validationErrors: []
