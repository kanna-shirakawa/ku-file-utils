# kubackup-server
KUBiC Labs utils for files management/archiving

WIP: just loading the project here from original package

from debian/control description:

some of utils contained here:

* ku-timestamp-rename: find the newest file in the directory tree,
  change di dir mtime accordlying, optional renames the dir
  prepending the resulting timestamp
* ku-storicize: archives a list of directories, optionally
  compressing, timestamping, and removing the original content
* ku-compressdir: simple frontend to different archive programs,
  for a simplified, uniform arguments format

* xlocate: a locate-like util, tailored for external disks
  management, and focused on portability (file tagging, files
  details, dbfile plain text format)
* xlocate-diskinfos: a companion for xlocate, to extract and
  store some usefull infos of external disks (desc, size, usage,
  fstype of main partition, etc)

* 7z-rmo: emulates beheaviour of 'zip -rmo' for p7zip files
* fast_fingerprint: really fast pseudo-md5 files fingerprint
* fdupe: search file dupes (using fast fingerprint)

* bscp: rsync-like scp, for block devices (imported, not mine)
* mkfs.ext4-nonlazy: just a wrapper to run with lazy_init_table=0

# RELEASES

you can get prebuilt .deb packages from here: https://repos.kubit.ch
