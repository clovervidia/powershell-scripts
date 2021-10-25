# PowerShell Scripts

A collection of PowerShell scripts I've written to help with automating tasks.

## exif-data.ps1

Based on <https://www.tabsoverspaces.com/233463-renaming-files-based-on-exif-data-in-powershell>.

A relatively simple script that extracts EXIF data from images. I wanted a way to sort images by their focal length property, which would tell me which camera on my phone I used to take them. This script extracts the focal length and a few other properties into a dictionary, allowing you to easily sort and group the images.

As an example, this is how you could use the script to grab the EXIF data from all of the images in a folder and group them by focal length.

```powershell
dir *.jpg | % {Get-EXIFData $_} | Group-Object {$_.FocalLength}
```

You could also use it to rename images based on when they were taken, which is what the original author wrote and used the script for.

The properties it currently extracts are:

- Date/Time Taken
- Camera Make
- Camera Model
- Lens Focal Length
- Software Used
- Image Width
- Image Height
- Image Orientation
- Flash
- GPS Latitude
- GPS Latitude Reference
- GPS Longitude
- GPS Longitude Reference

## totalvideolength.ps1

Takes in video files and returns the total length as a TimeSpan object. You can pipe in output from `Get-ChildItem` or pass in names or paths as arguments.

```powershell
dir -recurse *.ts | Get-TotalVideoLength
Get-TotalVideoLength file.mp4
```
