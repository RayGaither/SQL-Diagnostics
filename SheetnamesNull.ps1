$excel = New-Object -Com Excel.Application
$wb = $excel.Workbooks.Open("D:\DHPace\BaselinePreSAN\NonClustered-Instances\SQL5-2015-12-inst-Callrecord_diag.xlsx")


for ($i = 1; $i -le $wb.Sheets.Count; $i++)
{

$sh = $wb.Sheets.Item($i)
$str = $sh.Cells.Item(1,1).Value2

if ([string]::IsNullOrEmpty($str)) { $print = "Empty Sheet" } else {$print = "Has Results" }
$sh = $wb.Sheets.Item($i)
$sh.Name + '-' + $print

}

$excel.Workbooks.Close()

#END################################


