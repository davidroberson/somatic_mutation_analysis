class: Workflow
cwlVersion: v1.1
label: somatic_mutation_analysis
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ScatterFeatureRequirement
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: maf
  type: File[]?
  sbg:x: -70
  sbg:y: 205

outputs:
- id: oncoplots
  type: File?
  outputSource:
  - oncoplot/oncoplot
  sbg:x: 574.1786499023438
  sbg:y: 472
- id: summary_plot
  type: File?
  outputSource:
  - maftools_read_and_summary/summary_plot
  sbg:x: 318.9014892578125
  sbg:y: 86
- id: signatures_plot
  type: File?
  outputSource:
  - somatic_signatures/signatures_plot
  sbg:x: 619.1786499023438
  sbg:y: 0
- id: signature_heatmap
  type: File?
  outputSource:
  - somatic_signatures/signature_heatmap
  sbg:x: 619.1786499023438
  sbg:y: 107
- id: cophenetic_plot
  type: File?
  outputSource:
  - somatic_signatures/cophenetic_plot
  sbg:x: 629.1786499023438
  sbg:y: 240
- id: APOBEC
  type: File?
  outputSource:
  - somatic_signatures/APOBEC
  sbg:x: 633.1786499023438
  sbg:y: 355

steps:
- id: oncoplot
  label: oncoplot
  in:
  - id: maf_object
    source: maftools_read_and_summary/maf_object
  scatter:
  - maf_object
  run:
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
  out:
  - id: oncoplot
  sbg:x: 318.9014892578125
  sbg:y: 342
- id: maftools_read_and_summary
  label: maftools_read_and_summary
  in:
  - id: maf
    source: maf
  scatter:
  - maf
  run:
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
  out:
  - id: summary_plot
  - id: maf_object
  sbg:x: 105
  sbg:y: 207
- id: somatic_signatures
  label: somatic_signatures
  in:
  - id: maf_object
    source: maftools_read_and_summary/maf_object
  scatter:
  - maf_object
  run:
    class: CommandLineTool
    cwlVersion: v1.1
    label: somatic_signatures
    $namespaces:
      sbg: https://sevenbridges.com

    requirements:
    - class: DockerRequirement
      dockerPull: cgc-images.sbgenomics.com/david.roberson/maftools:210125
    - class: InitialWorkDirRequirement
      listing:
      - entryname: somatic_signatures.R
        writable: false
        entry: |-
          require(maftools)
          library(BSgenome.Hsapiens.UCSC.hg38, quietly = TRUE)
          library("NMF")

          source("cwl_inputs.R")

          maf = readRDS(maf_object_path)

          tri_nuc_matrix = trinucleotideMatrix(maf, ref_genome = "BSgenome.Hsapiens.UCSC.hg38")

          png('APOBEC_diff.png', width = 1280, height = 800, pointsize=20)
          plotApobecDiff(tnm = tri_nuc_matrix, maf = maf, pVal = 0.2)
          dev.off()

          png('Cophenetic.png', width = 1280, height = 800, pointsize=20)
          estimated_signatures = estimateSignatures(mat = tri_nuc_matrix, nTry = 6)
          plotCophenetic(res = estimated_signatures)
          dev.off()

          png('signatures_plot.png', width = 1280, height = 800, pointsize=20)
          extracted_signatures = extractSignatures(mat = tri_nuc_matrix, n = 3)
          maftools::plotSignatures(nmfRes = extracted_signatures, title_size = 1.2, sig_db = "SBS")
          dev.off()

          png('signature_heatmap.png', width = 1280, height = 800, pointsize=20)
          compar_30_signatures = compareSignatures(nmfRes = extracted_signatures, sig_db = "legacy")
          pheatmap::pheatmap(mat = compar_30_signatures$cosine_similarities, cluster_rows = FALSE, main = "cosine similarity against validated signatures")
          #laml_v3_cosm = compareSignatures(nmfRes = extracted_signatures, sig_db = "SBS")
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
    - id: APOBEC
      type: File?
      outputBinding:
        glob: APOBEC_diff.png
        outputEval: $(inheritMetadata(self, inputs.maf_object))
    - id: cophenetic_plot
      type: File?
      outputBinding:
        glob: Cophenetic.png
        outputEval: $(inheritMetadata(self, inputs.maf_object))
    - id: signature_heatmap
      type: File?
      outputBinding:
        glob: signature_heatmap.png
        outputEval: $(inheritMetadata(self, inputs.maf_object))
    - id: signatures_plot
      type: File?
      outputBinding:
        glob: signatures_plot.png
        outputEval: $(inheritMetadata(self, inputs.maf_object))

    baseCommand:
    - Rscript somatic_signatures.R

    hints:
    - class: sbg:SaveLogs
      value: '*.R'
    id: david.roberson/maftools-demo/somatic-signatures/5
    sbg:appVersion:
    - v1.1
    sbg:content_hash: a69ee4c9bbdf1e29b653580a529eeb7422d5d7a25679c0ea279e1c7d7745a7f8c
    sbg:contributors:
    - david.roberson
    sbg:createdBy: david.roberson
    sbg:createdOn: 1611592614
    sbg:id: david.roberson/maftools-demo/somatic-signatures/5
    sbg:image_url:
    sbg:latestRevision: 5
    sbg:modifiedBy: david.roberson
    sbg:modifiedOn: 1611595772
    sbg:project: david.roberson/maftools-demo
    sbg:projectName: maftools demo
    sbg:publisher: sbg
    sbg:revision: 5
    sbg:revisionNotes: require(maftools)
    sbg:revisionsInfo:
    - sbg:modifiedBy: david.roberson
      sbg:modifiedOn: 1611592614
      sbg:revision: 0
      sbg:revisionNotes:
    - sbg:modifiedBy: david.roberson
      sbg:modifiedOn: 1611592992
      sbg:revision: 1
      sbg:revisionNotes: ''
    - sbg:modifiedBy: david.roberson
      sbg:modifiedOn: 1611593061
      sbg:revision: 2
      sbg:revisionNotes: ''
    - sbg:modifiedBy: david.roberson
      sbg:modifiedOn: 1611595001
      sbg:revision: 3
      sbg:revisionNotes: ''
    - sbg:modifiedBy: david.roberson
      sbg:modifiedOn: 1611595370
      sbg:revision: 4
      sbg:revisionNotes: ''
    - sbg:modifiedBy: david.roberson
      sbg:modifiedOn: 1611595772
      sbg:revision: 5
      sbg:revisionNotes: require(maftools)
    sbg:sbgMaintained: false
    sbg:validationErrors: []
  out:
  - id: APOBEC
  - id: cophenetic_plot
  - id: signature_heatmap
  - id: signatures_plot
  sbg:x: 318.9014892578125
  sbg:y: 214
id: |-
  https://cgc-api.sbgenomics.com/v2/apps/david.roberson/maftools-demo/somatic-mutation-analysis/6/raw/
sbg:appVersion:
- v1.1
sbg:content_hash: a4ccf4aed2e6e1945e9839f6783e651d34dda2bf34ac969098081d6e370d79e49
sbg:contributors:
- david.roberson
sbg:createdBy: david.roberson
sbg:createdOn: 1611589223
sbg:id: david.roberson/maftools-demo/somatic-mutation-analysis/6
sbg:image_url:
sbg:latestRevision: 6
sbg:modifiedBy: david.roberson
sbg:modifiedOn: 1611595780
sbg:project: david.roberson/maftools-demo
sbg:projectName: maftools demo
sbg:publisher: sbg
sbg:revision: 6
sbg:revisionNotes: ''
sbg:revisionsInfo:
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1611589223
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1611589281
  sbg:revision: 1
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1611593140
  sbg:revision: 2
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1611594690
  sbg:revision: 3
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1611595018
  sbg:revision: 4
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1611595386
  sbg:revision: 5
  sbg:revisionNotes: ''
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1611595780
  sbg:revision: 6
  sbg:revisionNotes: ''
sbg:sbgMaintained: false
sbg:validationErrors: []
