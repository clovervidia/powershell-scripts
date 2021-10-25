function Get-TotalVideoLength {
	param([Parameter(Mandatory,ValueFromPipeline)][System.IO.FileInfo[]]$files);
	
	begin {
		$totalTime = New-TimeSpan;
	}
	
	process {
		foreach($file in $files) {
			$totalTime += [timespan]::parse((ffprobe $file -show_entries format=duration -print_format json -sexagesimal -loglevel -8 | ConvertFrom-Json).format.duration)
		}
	}
	
	end {
		return $totalTime;
	}
}
