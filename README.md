# NAMD Application for SC24

To download benchmarks: `./download_benchmarks`

To download all up-to-date binaries: `./download_binaries`

To download source-code from gitlab (needs granted access, alongside SSH-key): `./download_namd`

## Folder Structure

| Folder     | Purpose                                                      |
|------------|--------------------------------------------------------------|
| benchmarks | Houses benchmark datasets, each in their own subdirectory    |
| namd-bin   | Where official NAMD binaries are put, also in subdirectories |
| namd       | Git source code for NAMD                                     |
| outputs    | Output job-files                                             |

## TODOs

- [X] write download script for benchmarks
- [X] write download script for namd3 binary/source
- [ ] write compile script
- [ ] migrate run scripts
- [ ] parse and interpret results
