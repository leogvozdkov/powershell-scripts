# 
# Script for deleting columns and rows after choosen ones.
#
#


$Excel = New-Object -ComObject Excel.Application

$ExcelFile = Read-Host "file:" 
$list_number = Read-Host "Sheet's number:"
$true_last_column = Read-Host "last column to save:"
$true_last_row = Read-Host "last row to save:"

$doc = $Excel.Workbooks.Open($ExcelFile)
$list = $doc.Worksheets.Item(1)
$used = $list.usedRange
$lastrow = $used.SpecialCells(11).row
$lastcol = $used.SpecialCells(11).column


for ($i = $lastcol; $i -ge $true_last_column; $i--) {
    [void]$list.Columns($i).Delete()
}

for ($i = $lastrow; $i -ge $true_last_row; $i--) {
    [void]$list.Rows($i).Delete()
}