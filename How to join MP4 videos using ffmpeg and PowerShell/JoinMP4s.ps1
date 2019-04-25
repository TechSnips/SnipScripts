#region demo
Throw "This is a demo, dummy!"
#endregion
#region clean
Function Prompt(){}
Clear-Host
#endregion

# http://ffmpeg.org/download.html
# https://trac.ffmpeg.org/wiki/Concatenate

#region Prep
# Go to the correct location
Get-ChildItem D:\TechSnips\Demo

# Path to ffmpeg
$ffmpeg = '.\ffmpeg\bin\ffmpeg.exe'

# Path to ffprobe (for verification)
$ffprobe = '.\ffmpeg\bin\ffprobe.exe'

# Path to the files
$file1 = '.\setupAksClusterTake2Part1.mp4'
$file2 = '.\setupAksClusterTake2Part2.mp4'

# Current status
(& $ffprobe $file1 -v quiet -of json -show_format | ConvertFrom-Json).format
(& $ffprobe $file2 -v quiet -of json -show_format | ConvertFrom-Json).format

# Transcode them to MPEG-2 transport streams (H.264 video and AAC audio)
& $ffmpeg -y -i $file1 -c copy -bsf:v h264_mp4toannexb -f mpegts temp1.ts
& $ffmpeg -y -i $file2 -c copy -bsf:v h264_mp4toannexb -f mpegts temp2.ts

# Temp file status
(& $ffprobe .\temp1.ts -v quiet -of json -show_format | ConvertFrom-Json).format

# Concat them together
& $ffmpeg -f mpegts -i "concat:temp1.ts|temp2.ts" -c copy -bsf:a aac_adtstoasc output.mp4

# Final file
(& $ffprobe output.mp4 -v quiet -of json -show_format | ConvertFrom-Json).format

#endregion

#region As a function!
Function Join-ffmpegMp4 {
    param (
        [Parameter(
            ValueFromPipeline = $true
        )]
        [ValidateScript({
            $_.Name -match '\.mp4'
        })]
        [System.IO.FileInfo[]]$Files,
        [System.IO.DirectoryInfo]$TempFolder,
        [System.IO.FileInfo]$OutputFile,
        [string]$ffmpeg = 'D:\TechSnips\Demo\ffmpeg\bin\ffmpeg.exe'
    )
    Begin{
        [string[]]$outFiles = @()
    }
    Process {
        foreach ($file in $Files){
            # Create all the tmp files
            $tmpFile = "$($TempFolder.FullName)$($file.BaseName).ts"
            & $ffmpeg -y -i "$($file.FullName)" -c copy -bsf:v h264_mp4toannexb -f mpegts $tmpFile -v quiet
            [string[]]$outFiles += $tmpFile
        }
    }
    End {
        # Join them
        $concatString = "concat:" + ($outFiles -join '|')
        & $ffmpeg -f mpegts -i $concatString -c copy -bsf:a aac_adtstoasc $OutputFile -v quiet
        # Clean up
        foreach ($file in $outFiles){
            Remove-Item $file -Force
        }
    }
}

# Usage
$files = 'D:\TechSnips\Demo\setupAksClusterTake2Part1.mp4', 'D:\TechSnips\Demo\setupAksClusterTake2Part2.mp4'
Join-ffmpegMp4 -Files $files -OutputFile .\output2.mp4 -TempFolder .\

# Verify
(& $ffprobe output2.mp4 -v quiet -of json -show_format | ConvertFrom-Json).format

# Or use the pipeline
Get-ChildItem -Filter *.mp4 | Join-ffmpegMp4 -OutputFile .\output3.mp4 -TempFolder .\

# Verify
(& $ffprobe output3.mp4 -v quiet -of json -show_format | ConvertFrom-Json).format
#endregion