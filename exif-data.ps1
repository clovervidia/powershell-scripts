# Based on https://www.tabsoverspaces.com/233463-renaming-files-based-on-exif-data-in-powershell

function Get-EXIFData {
	param([string]$file)

	# The date the image was taken.
	function GetDateTaken($image) {
		try {
			$dateTakenData = $image.GetPropertyItem(0x9003).Value;
			$dateTakenValue = [System.Text.Encoding]::Default.GetString($dateTakenData, 0, $dateTakenData.Length - 1);
			$dateTaken = [DateTime]::ParseExact($dateTakenValue, 'yyyy:MM:dd HH:mm:ss', $null);
			return $dateTaken;
		}
		catch {
			return $null;
		}
	}

	# The make of the camera.
	function GetCameraMake($image) {
		try {
			$makeData = $image.GetPropertyItem(0x010F).Value;
			$makeValue = [System.Text.Encoding]::Default.GetString($makeData, 0, $makeData.Length - 1);
			return $makeValue;
		}
		catch {
			return $null;
		}
	}

	# The model of the camera.
	function GetCameraModel($image) {
		try {
			$modelData = $image.GetPropertyItem(0x0110).Value;
			$modelValue = [System.Text.Encoding]::Default.GetString($modelData, 0, $modelData.Length - 1);
			return $modelValue;
		}
		catch {
			return $null;
		}
	}

	# The focal length of the lens.
	function GetFocalLength($image) {
		try {
			$focalLengthData = $image.GetPropertyItem(0x920A).Value;
			$focalLengthValue = [System.BitConverter]::ToUInt32($focalLengthData, 0)/[System.BitConverter]::ToUInt32($focalLengthData, 4);
			return $focalLengthValue;
		}
		catch {
			return $null;
		}
	}

	# The software used to edit the image. Can be any number of things, like image editing software on a computer or camera settings.
	function GetSoftwareUsed($image) {
		try {
			$softwareData = $image.GetPropertyItem(0x0131).Value;
			$softwareValue = [System.Text.Encoding]::Default.GetString($softwareData, 0, $softwareData.Length - 1);
			return $softwareValue;
		}
		catch {
			return $null;
		}
	}

	# The image width.
	function GetImageWidth($image) {
		try {
			$imageWidthData = $image.GetPropertyItem(0x0100).Value;
			$imageWidthValue = [System.BitConverter]::ToUInt16($imageWidthData, 0);
			return $imageWidthValue;
		}
		catch {
			return $null;
		}
	}

	# The image height.
	function GetImageHeight($image) {
		try {
			$imageHeightData = $image.GetPropertyItem(0x0101).Value;
			$imageHeightValue = [System.BitConverter]::ToUInt16($imageHeightData, 0);
			return $imageHeightValue;
		}
		catch {
			return $null;
		}
	}

	# The orientation of the image.
	function GetOrientation($image) {
		try {
			$orientationData = $image.GetPropertyItem(0x0112).Value;
			$orientationValue = [System.BitConverter]::ToUInt16($orientationData, 0);
			return $orientationValue;
		}
		catch {
			return $null;
		}
	}

	# The flash status.
	function GetFlash($image) {
		try {
			$flashData = $image.GetPropertyItem(0x9209).Value;
			$flashValue = [System.BitConverter]::ToUInt16($flashData, 0);
			return $flashValue;
		}
		catch {
			return $null;
		}
	}

	# The GPS latitude reference. This will either be "N" for North or "S" for South.
	function GetGPSLatitudeReference($image) {
		try {
			$gpsLatRefData = $image.GetPropertyItem(0x0001).Value;
			$gpsLatRefValue = [System.Text.Encoding]::Default.GetString($gpsLatRefData, 0, 2);
			return $gpsLatRefValue;
		}
		catch {
			return $null;
		}
	}

	# The GPS latitude in degrees, minutes, and seconds.
	function GetGPSLatitude($image) {
		try {
			$gpsLatData = $image.GetPropertyItem(0x0002).Value;
			$gpsLatValue = "{0}° {1}' {2}""" -f ([System.BitConverter]::ToUInt32($gpsLatData, 0)/[System.BitConverter]::ToUInt32($gpsLatData, 4)),([System.BitConverter]::ToUInt32($gpsLatData, 8)/[System.BitConverter]::ToUInt32($gpsLatData, 12)), ([System.BitConverter]::ToUInt32($gpsLatData, 16)/[System.BitConverter]::ToUInt32($gpsLatData, 20));
			return $gpsLatValue;
		}
		catch {
			return $null;
		}
	}

	# The GPS longitude reference. This will either be "E" for East or "W" for West.
	function GetGPSLongitudeReference($image) {
		try {
			$gpsLonRefData = $image.GetPropertyItem(0x0003).Value;
			$gpsLonRefValue = [System.Text.Encoding]::Default.GetString($gpsLonRefData, 0, 2);
			return $gpsLonRefValue;
		}
		catch {
			return $null;
		}
	}

	# The GPS longitude in degrees, minutes, and seconds.
	function GetGPSLongitude($image) {
		try {
			$gpsLonData = $image.GetPropertyItem(0x0004).Value;
			$gpsLonValue = "{0}° {1}' {2}""" -f ([System.BitConverter]::ToUInt32($gpsLonData, 0)/[System.BitConverter]::ToUInt32($gpsLonData, 4)),([System.BitConverter]::ToUInt32($gpsLonData, 8)/[System.BitConverter]::ToUInt32($gpsLonData, 12)), ([System.BitConverter]::ToUInt32($gpsLonData, 16)/[System.BitConverter]::ToUInt32($gpsLonData, 20));
			return $gpsLonValue;
		}
		catch {
			return $null;
		}
	}

	$image = New-Object System.Drawing.Bitmap -ArgumentList $file
	try {
		$imageData = @{};
		$taken = GetDateTaken($image);
		$imageData["DateTaken"] = $taken;

		$model = GetCameraMake($image);
		$imageData["CameraMake"] = $model;

		$model = GetCameraModel($image);
		$imageData["CameraModel"] = $model;

		$focalLength = GetFocalLength($image);
		$imageData["FocalLength"] = $focalLength;

		$softwareUsed = GetSoftwareUsed($image);
		$imageData["SoftwareUsed"] = $softwareUsed;

		$imageWidth = GetImageWidth($image);
		$imageData["ImageWidth"] = $imageWidth;

		$imageHeight = GetImageHeight($image);
		$imageData["ImageHeight"] = $imageHeight;

		$orientation = GetOrientation($image);
		$imageData["Orientation"] = $orientation;

		$flash = GetFlash($image);
		$imageData["Flash"] = $flash;

		$gpsLatRef = GetGPSLatitudeReference($image);
		$imageData["GPSLatitudeReference"] = $gpsLatRef;

		$gpsLat = GetGPSLatitude($image);
		$imageData["GPSLatitude"] = $gpsLat;

		$gpsLonRef = GetGPSLongitudeReference($image);
		$imageData["GPSLongitudeReference"] = $gpsLonRef;

		$gpsLon = GetGPSLongitude($image);
		$imageData["GPSLongitude"] = $gpsLon;

		return $imageData;
	}
	finally {
		$image.Dispose();
	}
}
