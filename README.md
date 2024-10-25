# NAMD Application for SC24

To download benchmarks: `./download_benchmarks.sh`

To download all up-to-date binaries: `./download_binaries.sh`

To download major-release source-code: `./download_src.sh`

For compiling: `./build.sh`

## Folder Structure

| Folder     | Purpose                                                   |
|------------|-----------------------------------------------------------|
| benchmarks | Houses benchmark datasets, each in their own subdirectory |
| namd-bin   | Where NAMD binaries are put                               |
| namd-src   | Source code for NAMD                                      |
| outputs    | Output job-files                                          |

## TODOs

- [X] write download script for benchmarks
- [X] write download script for namd3 binary/source
- [ ] write compile script
- [ ] migrate run scripts
- [ ] parse and interpret results
