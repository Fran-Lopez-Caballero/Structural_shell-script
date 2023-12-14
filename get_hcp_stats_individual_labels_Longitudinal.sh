#! /bin/sh -ex
#Get freesurfer MRI Anatomical ROI Statistics for longitudinal struct comparisons

# 1) Since longitudinal-comparisons-ready files (e.g. xxxx.long.xxxx_Long_C) are modified relative to the original HCPproc files, we define HCP rois for them using the original ones from HCPproc but ajusting for any potential differences between the two files using mri_surf2surf.
# 2) Once that is done, the extraction of structural values to a .txt for plotting purposes follows the same procedures than in any traditional analysis

# Example names of longitudinal-comparisons-ready files:
# xxxx.long.xxxx_Long_C would be A values ready to be compared with C values
# xxxx.long.xxxx_Long_C would be C values ready to be compared with the previous file name (Baseline)

# Define save directories
Save_directory_Baseline="/Private/Path/Project/User/Cross_studies_data/Longitudinal_structural/Values/Baseline"
Save_directory_Followup="/Private/Path/Project/User/Cross_studies_data/Longitudinal_structural/Values/Followup"

# Subjects (IMPORTANT: No letter at the end)
SUBJECTS="xxxx xxxx"

# All HCP parcel labels
LABELS="10d 10pp 10r 10v 11l 13l 1 23c 23d 24dd 24dv 25 2 31a 31pd 31pv 33pr 3a 3b 43 44 45 46 47l 47m 47s 4 52 55b 5L 5m 5mv 6a 6d 6ma 6mp 6r 6v 7AL 7Am 7PC 7PL 7Pm 7m 8Ad 8Av 8BL 8BM 8C 9-46d 9a 9m 9p A1 A4 A5 AAIC AIP AVI DVT EC FEF FFC FOP1 FOP2 FOP3 FOP4 FOP5 FST H IFJa IFJp IFSa IFSp IP0 IP1 IP2 IPS1 Ig LBelt LIPd LIPv LO1 LO2 LO3 MBelt MIP MI MST MT OFC OP1 OP2-3 OP4 PBelt PCV PEF PF PFcm PFm PFop PFt PGi PGp PGs PHA1 PHA2 PHA3 PHT PH PIT PI POS1 POS2 PSL PeEc Pir PoI1 PoI2 PreS ProS RI RSC SCEF SFL STGa STSda STSdp STSva STSvp STV TA2 TE1a TE1m TE1p TE2a TE2p TF TGd TGv TPOJ1 TPOJ2 TPOJ3 V1 V2 V3A V3B V3CD V3 V4 V4t V6A V6 V7 V8 VIP"

# Both hemispheres
HEMIS="lh rh"

for SUBJECT in ${SUBJECTS[*]} 
do 

# Define follow-up strings accordingly
if [ $SUBJECT == "xxxx" ] || [ $SUBJECT == "xxxx" ] || [ $SUBJECT == "xxxx" ] || [ $SUBJECT == "xxxx" ] || [ $SUBJECT == "xxxx" ] || [ $SUBJECT == "xxxx" ]; then
	FOLLOWUP_LABEL="D"	
else
	FOLLOWUP_LABEL="C"
fi

# Create directory to store HCP labels to be extracted from HCP atlas

# In baseline longitudinal files
mkdir /Private/Path/Project/MRI/${SUBJECT}A.long.${SUBJECT}_Long_${FOLLOWUP_LABEL}/label/HCP
# In follow-up longitudinal files
mkdir /Private/Path/Project/MRI/${SUBJECT}${FOLLOWUP_LABEL}.long.${SUBJECT}_Long_${FOLLOWUP_LABEL}/label/HCP

	for HEMI in ${HEMIS[*]}
	do

		# Determine label based on hemisphere for later use
		if [ $HEMI == "lh" ]; then
			HEMI_LABEL="L"
		elif [ $HEMI == "rh" ]; then
			HEMI_LABEL="R"
		else
			echo "no coincidence"
		fi

		# Define HCP atlas in longitudinal ready files using original files

		# In Baseline files (e.g. xxxx.long.2140_Long_C)
		mri_surf2surf --srcsubject ${SUBJECT}A --trgsubject ${SUBJECT}A.long.${SUBJECT}_Long_${FOLLOWUP_LABEL} --hemi ${HEMI} --sval-annot /Private/Path/Project/MRI/${SUBJECT}A/label/${HEMI}.HCPMMP1.annot --tval /Private/Path/Project/MRI/${SUBJECT}A.long.${SUBJECT}_Long_${FOLLOWUP_LABEL}/label/${HEMI}.HCPMMP1.annot

		# In follow-up files (e.g. 2140C.long.2140_Long_C)
		mri_surf2surf --srcsubject ${SUBJECT}${FOLLOWUP_LABEL} --trgsubject ${SUBJECT}${FOLLOWUP_LABEL}.long.${SUBJECT}_Long_${FOLLOWUP_LABEL} --hemi ${HEMI} --sval-annot /Private/Path/Project/MRI/${SUBJECT}${FOLLOWUP_LABEL}/label/${HEMI}.HCPMMP1.annot --tval /Private/Path/Project/MRI/${SUBJECT}${FOLLOWUP_LABEL}.long.${SUBJECT}_Long_${FOLLOWUP_LABEL}/label/${HEMI}.HCPMMP1.annot

		# Define file name of output from this step
		output_name_baseline="/Private/Path/Project/MRI/${SUBJECT}A.long.${SUBJECT}_Long_${FOLLOWUP_LABEL}/label/${HEMI}.HCPMMP1.annot"
		output_name_followup="/Private/Path/Project/MRI/${SUBJECT}${FOLLOWUP_LABEL}.long.${SUBJECT}_Long_${FOLLOWUP_LABEL}/label/${HEMI}.HCPMMP1.annot"

		# Indicate feedback on whether the output is present (meaning procedure ran well)
		if [ -f "$output_name_baseline" ] && [ -f "$output_name_followup" ]; then
			echo -e "\e[4;32m mri_surf2surf ran correctly for ${SUBJECT} \e[0m"
		else
			echo -e "\e[4;31m something went wrong on mmri_surf2surf for ${SUBJECT}, continue for now... \e[0m"

			# Normally it would stop but for the purpose of identifying all subjects with problems at once, continue.
			# exit 
		fi

		# Extract labels from atlas in longitudinal-ready folders

		# In Baseline file for this subject
		mri_annotation2label --subject ${SUBJECT}A.long.${SUBJECT}_Long_${FOLLOWUP_LABEL} --annotation /Private/Path/Project/MRI/${SUBJECT}A.long.${SUBJECT}_Long_${FOLLOWUP_LABEL}/label/${HEMI}.HCPMMP1.annot --hemi ${HEMI} --outdir /Private/Path/Project/MRI/${SUBJECT}A.long.${SUBJECT}_Long_${FOLLOWUP_LABEL}/label/HCP 

		# In follow-up file for this subject
		mri_annotation2label --subject ${SUBJECT}${FOLLOWUP_LABEL}.long.${SUBJECT}_Long_${FOLLOWUP_LABEL} --annotation /Private/Path/Project/MRI/${SUBJECT}${FOLLOWUP_LABEL}.long.${SUBJECT}_Long_${FOLLOWUP_LABEL}/label/${HEMI}.HCPMMP1.annot --hemi ${HEMI} --outdir /Private/Path/Project/MRI/${SUBJECT}${FOLLOWUP_LABEL}.long.${SUBJECT}_Long_${FOLLOWUP_LABEL}/label/HCP 

		# Define file name of output from this step (any HCP roi name will suffice)
		output_name_baseline="/Private/Path/Project/MRI/${SUBJECT}A.long.${SUBJECT}_Long_${FOLLOWUP_LABEL}/label/HCP/${HEMI}.${HEMI_LABEL}_1_ROI.label"
		output_name_followup="/Private/Path/Project/MRI/${SUBJECT}${FOLLOWUP_LABEL}.long.${SUBJECT}_Long_${FOLLOWUP_LABEL}/label/HCP/${HEMI}.${HEMI_LABEL}_1_ROI.label"

		# Indicate feedback on whether the output is present (meaning procedure ran well)
		if [ -f "$output_name_baseline" ] && [ -f "$output_name_followup" ]; then
			echo -e "\e[4;32m mri_annotation2label ran correctly for ${SUBJECT} ${HEMI_LABEL} \e[0m"
		else
			echo -e "\e[4;31m something went wrong on mri_annotation2label for ${SUBJECT} ${HEMI_LABEL}, continue for now... \e[0m"
			# Normally it would stop but for the purpose of identifying all subjects with problems at once, continue.
			# exit 
		fi

		# Extract volume and thickness for each ROI
		for LABEL in ${LABELS[*]}
		do

			# For Baseline subjects
			mkdir ${Save_directory_Baseline}
			mris_anatomical_stats -l /Private/Path/Project/MRI/${SUBJECT}A.long.${SUBJECT}_Long_${FOLLOWUP_LABEL}/label/HCP/${HEMI}.${HEMI_LABEL}_${LABEL}_ROI.label -f ${Save_directory_Baseline}/FS_stats_${HEMI}.${LABEL}.log ${SUBJECT}A.long.${SUBJECT}_Long_${FOLLOWUP_LABEL} ${HEMI}
			printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" `grep "subjectname" ${Save_directory_Baseline}/FS_stats_${HEMI}.${LABEL}.log | awk '{print $NF}'` `tail -1 ${Save_directory_Baseline}/FS_stats_${HEMI}.${LABEL}.log` >> ${Save_directory_Baseline}/FS_stats_${HEMI}.${LABEL}.txt

			# For Followup subjects
			mkdir ${Save_directory_Followup}
			mris_anatomical_stats -l /Private/Path/Project/MRI/${SUBJECT}${FOLLOWUP_LABEL}.long.${SUBJECT}_Long_${FOLLOWUP_LABEL}/label/HCP/${HEMI}.${HEMI_LABEL}_${LABEL}_ROI.label -f ${Save_directory_Followup}/FS_stats_${HEMI}.${LABEL}.log ${SUBJECT}${FOLLOWUP_LABEL}.long.${SUBJECT}_Long_${FOLLOWUP_LABEL} ${HEMI}
			printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" `grep "subjectname" ${Save_directory_Followup}/FS_stats_${HEMI}.${LABEL}.log | awk '{print $NF}'` `tail -1 ${Save_directory_Followup}/FS_stats_${HEMI}.${LABEL}.log` >> ${Save_directory_Followup}/FS_stats_${HEMI}.${LABEL}.txt

		done	

		# Define file name of output from this step (any HCP roi name will suffice)
		output_name_baseline="${Save_directory_Baseline}/FS_stats_${HEMI}.1.txt"
		output_name_followup="${Save_directory_Followup}/FS_stats_${HEMI}.1.txt"

		# Indicate feedback on whether the output is present (meaning procedure ran well)
		if [ -f "$output_name_baseline" ] && [ -f "$output_name_followup" ]; then
			echo -e "\e[4;32m mris_anatomical_stats ran correctly for ${SUBJECT} ${HEMI_LABEL} \e[0m"
		else
			echo -e "\e[4;31m something went wrong on mris_anatomical_stats for ${SUBJECT} ${HEMI_LABEL}, continue for now... \e[0m"
			# Normally it would stop but for the purpose of identifying all subjects with problems at once, continue.
			# exit 
		fi
	done
done
