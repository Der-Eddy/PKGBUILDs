#!/usr/bin/env bash

readonly LINUX_STABLE='56-rc'

readonly LINUX_SCHED=('pds 0')
readonly LINUX_MARCH=('skylake' 'zen')
#readonly LINUX_MARCH=('skylake')

# Kernel setup/optimizations

kernel_setup() {
	git checkout customization.cfg PKGBUILD
	git pull -ff

	local _PKGBASE="linux-tkg-$3"

	sed -i'' "
	s/_NUKR=\"[^\"]*\"/_NUKR=\"false\"/g
	s/_OPTIPROFILE=\"[^\"]*\"/_OPTIPROFILE=\"1\"/g
	s/_modprobeddb=\"[^\"]*\"/_modprobeddb=\"false\"/g
	s/_menunconfig=\"[^\"]*\"/_menunconfig=\"false\"/g
	s/_diffconfig=\"[^\"]*\"/_diffconfig=\"false\"/g
	s/_cpusched=\"[^\"]*\"/_cpusched=\"$1\"/g
	s/_rr_interval=\"[^\"]*\"/_rr_interval=\"default\"/g
	s/_sched_yield_type=\"[^\"]*\"/_sched_yield_type=\"$2\"/g
	s/_ftracedisable=\"[^\"]*\"/_ftracedisable=\"true\"/g
	s/_numadisable=\"[^\"]*\"/_numadisable=\"false\"/g
	s/_tickless=\"[^\"]*\"/_tickless=\"2\"/g
	s/_voluntary_preempt=\"[^\"]*\"/_voluntary_preempt=\"true\"/g
	s/_acs_override=\"[^\"]*\"/_acs_override=\"true\"/g
	s/_amd_overdrive_flickering_fix=\"[^\"]*\"/_amd_overdrive_flickering_fix=\"false\"/g
	s/_ksm_uksm=\"[^\"]*\"/_ksm_uksm=\"true\"/g
	s/_bcachefs=\"[^\"]*\"/_bcachefs=\"false\"/g
	s/_bfqmq=\"[^\"]*\"/_bfqmq=\"true\"/g
	s/_zfsfix=\"[^\"]*\"/_zfsfix=\"true\"/g
	s/_fsync=\"[^\"]*\"/_fsync=\"true\"/g
	s/_umip_instruction_emulation=\"[^\"]*\"/_umip_instruction_emulation=\"true\"/g
	s/_processor_opt=\"[^\"]*\"/_processor_opt=\"$3\"/g
	s/_smt_nice=\"[^\"]*\"/_smt_nice=\"true\"/g
	s/_random_trust_cpu=\"[^\"]*\"/_random_trust_cpu=\"true\"/g
	s/_runqueue_sharing=\"[^\"]*\"/_runqueue_sharing=\"mc\"/g
	s/_timer_freq=\"[^\"]*\"/_timer_freq=\"750\"/g
	s/_user_patches=\"[^\"]*\"/_user_patches=\"false\"/g
	s/_custom_pkgbase=\"[^\"]*\"/_custom_pkgbase=\"$_PKGBASE\"/g
	" customization.cfg

	echo '[build-tkg] applied kernel customization'

	export TARGET_EXTRAPKGS='ccache'
}

# Get latest kernel PKGBUILD

readonly DIR=/home/eddy/cache/linux-tkg

git clone https://github.com/Frogging-Family/linux-tkg.git "$DIR"
cd "$DIR"

# Build

pushd "linux${LINUX_STABLE}-tkg"
for _VAR_SCHED in "${LINUX_SCHED[@]}"; do
	for _VAR_MARCH in "${LINUX_MARCH[@]}"; do
		kernel_setup $_VAR_SCHED $_VAR_MARCH
		_VAR=($_VAR_SCHED)
		/home/eddy/cache/build.sh
		/usr/bin/repoctl update
		unset TARGET_EXTRAPKGS
	done
done
popd

# Clean

#/home/eddy/cache/clean.sh
