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
