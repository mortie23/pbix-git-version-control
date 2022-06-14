param (
  [string]$reporoot = "./",
  [string]$filename = "null.pbix"
)
Write-Host $reporoot $filename

# Ignore the DataMashup 7zexpanded directory while compressing
Get-ChildItem $reporoot\$filename.expanded\* | 
Where-Object { $_.Name -notin ("DataMashup.7zexpanded") } | 
Compress-Archive -Force -DestinationPath $reporoot\$filename

# Remove the DataMashup archive after compression
Write-Host "Remove DataMashup $reporoot/$filename.expanded/DataMashup"
rm  $reporoot/$filename.expanded/DataMashup
