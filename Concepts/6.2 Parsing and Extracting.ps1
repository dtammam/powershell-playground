<#
Parsing and Extracting

    - Use find to find positions thata re relevant
    - Use substring positions with slice to take out a chunk of text that is relevant, like an email domain
#>

$data = 'From stephen.marquard@uct.ac.za Sat Jan  5 09:14:16 2008'

$atposition = $data | Select-String -pattern '@' -SimpleMatch
$atposition

# To be continued!