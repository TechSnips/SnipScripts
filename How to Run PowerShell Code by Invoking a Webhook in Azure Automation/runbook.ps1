param(
    [object]$WebhookData
)

## Validate we have a request body from the webhook
if ('RequestBody' -notin $WebhookData.PSObject.Properties.Name) {
    throw 'Required webhook request body not found.'
}

## https://stackoverflow.com/questions/22002748/hashtables-from-convertfrom-json-have-different-type-from-powershells-built-in-h
function ConvertPSObjectToHashtable
{
    param (
        [Parameter(ValueFromPipeline)]
        $InputObject
    )

    process
    {
        if ($null -eq $InputObject) { return $null }

        if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string])
        {
            $collection = @(
                foreach ($object in $InputObject) { ConvertPSObjectToHashtable $object }
            )

            Write-Output -NoEnumerate $collection
        }
        elseif ($InputObject -is [psobject])
        {
            $hash = @{}

            foreach ($property in $InputObject.PSObject.Properties)
            {
                $hash[$property.Name] = ConvertPSObjectToHashtable $property.Value
            }

            $hash
        }
        else
        {
            $InputObject
        }
    }
}

## Convert the incoming JSON to an object we can work with
$request = $WebhookData.RequestBody | ConvertFrom-Json

## Concert the incoming string representation of a scriptblock into an actual scriptblock
$expression = Invoke-Expression -Command $request.Expression.StartPosition.Content

if ($request.Parameters) {
    ## Convert incoming parameters property object to a hashtable for splatting
    $params = ConvertPSObjectToHashtable -InputObject $request.Parameters

    ## Create the param() block inside of the scriptblock so we can used named parameters
    $sb = 'param(${0}){1}' -f ($params.Keys -join ',$'),$expression.ToString()
    $expression = [scriptblock]::Create($sb)
    
    ## Execute the scriptblock passing parameters in
    & $expression @params
} else {
    ## Execute the scriptblock
    & $expression
}
