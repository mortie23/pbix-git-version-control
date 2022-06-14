# Modified from
# https://github.com/vivi90/git-zip
# Original:
#   Created: 2021 by Vivien Richter <vivien-richter@outlook.de>
#   License: CC-BY-4.0
#   Version: 1.0.0

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd 2>/dev/null)"
# Configuration
ARCHIVE_EXTENSIONS=pbix

# Processing
for EXTRACTED_ARCHIVE in $(git ls-tree -dr --full-tree --name-only HEAD | grep -iE "${ARCHIVE_EXTENSIONS}\.expanded$"); do
  echo ${EXTRACTED_ARCHIVE}
  # Gets filename
  FULLFILENAME=$(dirname $EXTRACTED_ARCHIVE)/$(basename $EXTRACTED_ARCHIVE | awk -F '.expanded' '{ print $1 }')
  echo "Removing ${FULLFILENAME}"
  # Removes the pbix file
  rm $FULLFILENAME
  # Jumps into the extracted archive
  cd $EXTRACTED_ARCHIVE
  # Create the DataMashup archive
  7z a DataMashup ./DataMashup.7zexpanded/*
  mv DataMashup.7z DataMashup
  # Jumps back
  cd ..
  # Creates the real archive file
  # Filename without leading dot slash
  FILENAME=$(echo "$FULLFILENAME" | sed -e "s/^\.\///g")
  exec powershell -File "${SCRIPT_DIR}\post-pbix-create.ps1" -reporoot $(dirname $SCRIPT_DIR) -filename $FILENAME
done
