#(get-childitem \\td-ereceipts-01\TotaleReceiptsServer\Receipt\Archive\*.txt).count

function Get-eReceiptValidationCheck
{
    [CmdletBinding()]
    param()

    Begin {
        $xmlFiles = (get-childitem \\td-ereceipts-01\TotaleReceiptsServer\Receipt\Archive\XtenderImports\PSG_INDEX.xml -Recurse)
        $psgIndex = @()
    }

    Process {
        
        foreach ($xmlFile in $xmlFiles)
        {
            $count = (Select-String -Path $xmlFile -Pattern "<AppID>0</AppID>").count
            $fullname = ($xmlFile.FullName).split('\')

            $psgIndex += [PSCustomObject]@{
                FullName = $fullname[-2] + '\' + $fullname[-1]
                NumberFilesNotImported = $count
                LastWriteTime = $xmlFile.LastWriteTime
            }
        }

        "`neReceipt Import Summary"
        "-----------------------`n"
        $psgIndex | Where-Object {$_.NumberFilesNotImported -gt 0}
    }

    End {}
}
