# Modified from
# https://github.com/vivi90/git-zip
# Original:
#   Created: 2021 by Vivien Richter <vivien-richter@outlook.de>
#   License: CC-BY-4.0
#   Version: 1.0.0

ARCHIVE_EXTENSIONS=pbix

# Processing
for STAGED_FILE in $(git diff --name-only --cached | grep -iE "\.($ARCHIVE_EXTENSIONS)$"); do
  echo "${STAGED_FILE}"
  # Deletes the old expanded files
  rm -rf "$(basename $STAGED_FILE).expanded"
  # Expands the pbix content
  if [ -f "$STAGED_FILE" ]; then
    unzip -o $STAGED_FILE -d "$(dirname $STAGED_FILE)/$(basename $STAGED_FILE).expanded"
    # DataMashup itself is expanded in the same directory
    7z x "$(dirname $STAGED_FILE)/$(basename $STAGED_FILE).expanded\DataMashup" -o"$(dirname $STAGED_FILE)/$(basename $STAGED_FILE).expanded\DataMashup.7zexpanded"
    # Cleaning up the binary files
    rm $(dirname $STAGED_FILE)/$(basename $STAGED_FILE).expanded/SecurityBindings
    rm $(dirname $STAGED_FILE)/$(basename $STAGED_FILE).expanded/DataMashup
  fi
  # Adds expanded or deleted archive content to the stage
  git add "$(dirname $STAGED_FILE)/$(basename $STAGED_FILE).expanded"
  # Removes the original pbix from the stage
  git reset ${STAGED_FILE}
done
