! Solaris ld doesn't support the linker plugin interface
! UNSUPPORTED: system-windows, system-solaris

! Full LTO and aliases.
! RUN: %flang -### -fuse-ld=lld -flto=full -flto-partitions=16 %s 2>&1 | FileCheck %s --check-prefix=LLD-PARTITION

! LLD-PARTITION: "-fc1"
! LLD-PARTITION-SAME: "-flto=full"
! LLD-PARTITION-SAME: "-flto-partitions=16"
! LLD-PARTITION: "--lto-partitions=16"

! RUN: %flang -### -fuse-ld=lld -flto -ffat-lto-objects %s 2>&1 | FileCheck %s --check-prefix=LLD-FAT-LTO

! LLD-FAT-LTO: "-fc1"
! LLD-FAT-LTO-SAME: "-flto=full"
! LLD-FAT-LTO-SAME: "-ffat-lto-objects"
! LLD-FAT-LTO: "--fat-lto-objects"