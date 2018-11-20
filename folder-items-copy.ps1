# Very simple program to copy contents of one directory to another
# Source the file before running. 
# Once file is sourced it can currently be ran using the following:
# Compare-Files ./di1/ ./di2/ 
# both relative and absolute paths should work. 
# REMEMBER it won't ask about overwritting files. So if source file is newer it will always overwrite destination 

function Compare-Files{
    param( 
        [Parameter(Position=0,Mandatory=$true)]
        [Alias("SourcePath")]
        [string]$source_list, 
        [Parameter(Position=1,Mandatory=$true)]
        [Alias("TargetPath")]
        [string]$destination )

    Write-Host "Source List: " $source_list
    
    if (Test-Path $source_list){
        $source_files = Get-ChildItem -Path $source_list -Recurse
    }
    else{
        Write-Host "Source path doesn't exist"
        return 
    }
    
    $source_item = Get-Item -Path $source_list

    Write-Host "-------"
    Write-Host "SOURCE"
    Write-Host $source_files.FullName
    Write-Host "-------"

    Write-Host $source_item.FullName
    foreach ($item in $source_files){
        Write-Host "file: " $item.FullName

        # if item that is to be copied exsists 
        if (Test-Path $item.FullName){

            # find substring match to build destination path
            if ($item.FullName -match ($source_item.FullName + "(.*)")){
                $path = $matches[1]
            }
            else {
                Write-Error "Error building destination path."
            }

            $targetFile = $destination  + $path
            Write-Host "target: " $targetFile

            # check if file exsists in target directory
            if (Test-Path $targetFile){
                Write-Host "File " $targetFile "exsists"

                # check if target item is older than source item
                # if source is newer overwrite target file
                if (Test-Path $targetFile -OlderThan $item.LastWriteTime){
                    Write-Host "Source item is newer"
                    $copied = Copy-Item -Path $item.FullName -destination $targetFile -PassThru -Force
                    Write-Host "---------------------------------------------------"
                    Write-Host "copied " $copied
                    Write-Host "---------------------------------------------------"
                }
                else {
                    Write-Host "Source item is older"
                }

            }
            # if item doesn't exsist in target directory copy item
            else {
                $copied = Copy-Item -Path $item.FullName -destination $targetFile -PassThru -Force
                Write-Host "---------------------------------------------------"
                Write-Host "copied " $copied
                Write-Host "---------------------------------------------------"
            }
        }

        else {
            Write-Error "Problem reading. Item can't be found " $item.FullName
        }
    }

}

