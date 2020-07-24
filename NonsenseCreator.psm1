function New-NonsenseWord
{
    <#
    .SYNOPSIS
    Create a nonsensical word.
    .DESCRIPTION
    Create a word without meaning. You may specify the length.  You may specify to include diacritics.  Words will be created with a 75% chance of alternating vowel to consonant.
    .PARAMETER Length
    [int] The length of the word.
    .PARAMETER IncludeDiacritics
    [switch] Switch to include diacritics (accents) on vowels.
    .EXAMPLE
    PS>New-NonsenseWord
    woqanuyowcefe
    .EXAMPLE
    PS>New-NonsenseWord -Length 5
    acojy
    .EXAMPLE
    PS>New-NonsenseWord -IncludeDiacritics
    yljízömudjf
    #>
    [CmdletBinding()]
    [OutputType('string')]
    param(
        [Parameter()]
        [ValidateRange(1,40)]
        [int]
        $Length
        ,
        [Parameter()]
        [switch]
        $IncludeDiacritics
        ,
        [Parameter(DontShow)]
        [System.Collections.ArrayList]
        $Letters
    )
    
    

    $Letters = [System.Collections.ArrayList]@()

    if( ! $PSBoundParameters.Keys.Contains('Length') )
    {
        $Length = Get-Random -Minimum 1 -Maximum 15
    }
    
    if($Length -eq 1)
    {
        $Letters.Add( [vowel]::new().Letter ) | Out-Null
    }
    else
    {
        $CurrentLetterType = [Vowel],[Consonant] | Get-Random
        1..$Length | Foreach-Object -Process {
            switch ($CurrentLetterType.Name) {
                "Vowel" { 
                    Write-Verbose "vowel"
                    if($IncludeDiacritics)
                    {
                        if((Get-Random -Minimum 1 -Maximum 6) -ge 5)
                        {
                            # Add a vowel with accent to the word
                            Write-Verbose "Diacritic"
                            $Letters.Add( [SpecialCharacter]::new($([Vowel]::new().Letter)).Letter ) | Out-Null
                        }else{
                            # Add a vowel to the word
                            $Letters.Add( [Vowel]::new().Letter ) | Out-Null
                        }
                        
                    }else{
                        # Add a vowel to the word
                        $Letters.Add( [Vowel]::new().Letter ) | Out-Null
                    }
                    $CurrentLetterType = [Vowel],[Consonant],[Consonant],[Consonant] | Get-Random
                }
                "Consonant" { 
                    # Add a consonant to the word
                    $Letters.Add( [Consonant]::new().Letter ) | Out-Null
                    # Set the next letter type, with 75% chance of being the other type
                    $CurrentLetterType = [Consonant],[Vowel],[Vowel],[Vowel] | Get-Random
                }
                Default {"huh"}
            }
        }

        # 1..$NumOfVowels | ForEach-Object -Process {
        #     $Letters.Add( [vowel]::new($false).Letter ) | Out-Null
        # }
        # $NumOfVowels..$Length | ForEach-Object -Process {
        #     $Letters.Add( [lowercase]::new().Letter ) | Out-Null
        # }
    }
    Write-Output ($Letters -join '')
}
function New-NonsenseSentence
{
    <#
    .SYNOPSIS
    Create a nonsensical sentence.
    .DESCRIPTION
    Create a nonsensical sentence using words you provide or let the function create the words. You may specify the length (number of words).  You may specify to include diacritics.  
    Words will be created with a 75% chance of alternating vowel to consonant. Sentences will begin with a capital letter, end with punctuation, and may include connecting punctuation like commas and semicolons.
    .PARAMETER Length
    [int] The length of the sentence (how many words).
    .PARAMETER IncludeDiacritics
    [switch] Switch to include diacritics (accents) on vowels.
    .PARAMETER WordList
    [string[]] Array of strings that will be used as the words included in the sentence.
    .EXAMPLE
    PS>New-NonsenseSentence
    Ivy gpyapl telp kpkyorlog iwarqymyite afikoehicus oijib hquscqby jowuanezuxem.
    .EXAMPLE
    PS>New-NonsenseSentence -Length 5
    Ma oykoqijdv fu epyyeetaxo felrosybypyo.
    .EXAMPLE
    PS>NNew-NonsenseSentence -WordList 'this','that','nothing','Jacob','a','uh','take','give'
    That give Jacob Jacob nothing take this!
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateRange(3,20)]
        [int]
        $Length
        ,
        [Parameter()]
        [switch]
        $IncludeDiacritics
        ,
        [Parameter()]
        [string[]]
        $WordList
        ,
        [Parameter(DontShow)]
        [System.Collections.ArrayList]
        $NewSentence
    )
    # Create sentence arraylist
    $NewSentence = [System.Collections.ArrayList]@()

    # Set length if not present
    if ( ! $PSBoundParameters.Keys.Contains('Length') )
    {
        $Length = Get-Random -Minimum 3 -Maximum 20
    }

    # Build sentence
    if ( ! $PSBoundParameters.Keys.Contains('WordList') )
    {
        1..$Length | ForEach-Object -Process {
            if($IncludeDiacritics)
            {
                $NewSentence.Add( (New-NonsenseWord -IncludeDiacritics) ) | Out-Null
            }else{
                $NewSentence.Add( (New-NonsenseWord) ) | Out-Null
            }
        }
    }
    else
    {
        1..$Length | ForEach-Object -Process {
            $NewSentence.Add( ($WordList | Get-Random) ) | Out-Null
        }
    }

    # Add punctuation
    if ($Length -gt 8 -and $Length -lt 15)
    {
        if((Get-Random -Minimum 1 -Maximum 10) -gt 5)
        {
            $InsertionPoint = (Get-Random -Minimum 2 -Maximum ($Length-2))
            $NewSentence[$InsertionPoint] = ($NewSentence[$InsertionPoint] + ([Punctuation]::new($true).Letter))
        }
        else
        {
            # Do not add connection punctuation
        }
    }

    # Add a final Punctuation
    $LastWord = $NewSentence[$Length-1]
    $LastWord = "$LastWord$([Punctuation]::new($false).Letter)"
    $NewSentence[$Length-1] = $LastWord

    # Capitalize the first letter
    $FirstWord = $NewSentence[0]
    if($FirstWord.Length -gt 1)
    {
        $FirstWordArray = $FirstWord.ToCharArray()
        $FirstWordArray[0] = $FirstWordArray[0].ToString().ToUpper()
        $NewSentence[0] = $FirstWordArray -join ''
    }
    else
    {
        $NewSentence[0] = $FirstWord.ToString().ToUpper()
    }
    # Output the final sentence
    Write-Output ($NewSentence -join ' ')
}
function New-NonsenseParagraph
{
    <#
    .SYNOPSIS
    Create a nonsensical paragraph.
    .DESCRIPTION
    Create a nonsensical paragraph using words you provide or let the function create the words. You may specify the length (number of sentences).  You may specify to include diacritics.  
    Words will be created with a 75% chance of alternating vowel to consonant. Sentences will begin with a capital letter, end with punctuation, and may include connecting punctuation like commas and semicolons.
    .PARAMETER Length
    [int] The length of the paragraph (numbers of sentences).
    .PARAMETER IncludeDiacritics
    [switch] Switch to include diacritics (accents) on vowels.
    .PARAMETER WordList
    [string[]] Array of strings that will be used as the words included in the paragraph.
    .EXAMPLE
    PS>New-NonsenseParagraph
    Ivy gpyapl telp kpkyorlog iwarqymyite afikoehicus oijib hquscqby jowuanezuxem.
    .EXAMPLE
    PS>New-NonsenseSentence -Length 5
    Ma oykoqijdv fu epyyeetaxo felrosybypyo.
    .EXAMPLE
    PS>NNew-NonsenseSentence -WordList 'this','that','nothing','Jacob','a','uh','take','give'
    That give Jacob Jacob nothing take this!
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [int]
        $SentenceCount
        ,
        [Parameter()]
        [switch]
        $IncludeDiacritics
        ,
        [Parameter()]
        [string[]]
        $WordList
        ,
        [Parameter(DontShow)]
        [System.Collections.ArrayList]
        $ThisParagraph
    )
    Begin 
    {
        if ( ! $PSBoundParameters.Keys.Contains('SentenceCount') )
        {
            $SentenceCount = Get-Random -Minimum 3 -Maximum 10
        }
        $ThisParagraph = [System.Collections.ArrayList]@()
        # Add initial tab to the paragraph
        $ThisParagraph.Add("`t") | Out-Null
    }
    Process 
    {
        1..$SentenceCount | ForEach-Object {
            if($WordList)
            {
                $ThisParagraph.Add((New-NonsenseSentence -WordList $WordList)) | Out-Null
            }else{
                if($IncludeDiacritics)
                {
                    $ThisParagraph.Add((New-NonsenseSentence -IncludeDiacritics)) | Out-Null
                }else{
                    $ThisParagraph.Add((New-NonsenseSentence)) | Out-Null
                }
            }
        }
    }
    End 
    {
        Write-Output ($ThisParagraph -join '  ')
    }
}
function New-NonsenseDocument
{
    <#
    .SYNOPSIS
    Create a nonsensical document.
    .DESCRIPTION
    Create a nonsensical document. You may specify the length (number of sentences).  You may specify to include diacritics.  
    Words will be created with a 75% chance of alternating vowel to consonant. Sentences will begin with a capital letter, end with punctuation, and may include connecting punctuation like commas and semicolons.
    .PARAMETER Path
    [string] The path of the document to create. Include the name of the document and extension type.
    .PARAMETER IncludeDiacritics
    [switch] Switch to include diacritics (accents) on vowels.
    .PARAMETER WordCount
    [int] The number of unique words to include in the document.  Accepts numbers from 10 to 600. If left undesignated, the random number will be from 10 to 200.
    .EXAMPLE
    PS>New-NonsenseDocument
    Ivy gpyapl telp kpkyorlog iwarqymyite afikoehicus oijib hquscqby jowuanezuxem.
    .EXAMPLE
    PS>New-NonsenseSentence -Length 5
    Ma oykoqijdv fu epyyeetaxo felrosybypyo.
    .EXAMPLE
    PS>NNew-NonsenseSentence -WordList 'this','that','nothing','Jacob','a','uh','take','give'
    That give Jacob Jacob nothing take this!
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $Path
        ,
        [Parameter()]
        [switch]
        $IncludeDiacritics
        ,
        [Parameter()]
        [ValidateRange(10,600)]
        [int]
        $WordCount
        ,
        [Parameter()]
        [switch]
        $Markdown
        ,
        [Parameter(DontShow)]
        [string[]]
        $WordList
        ,
        [Parameter(DontShow)]
        [System.Collections.ArrayList]
        $Document
        ,
        [Parameter(DontShow)]
        [string]
        $Heading
        ,
        [Parameter(DontShow)]
        [string]
        $SubHeading
        ,
        [Parameter(DontShow)]
        [string]
        $BoldWord
        ,
        [Parameter(DontShow)]
        [string]
        $ItalicWord
    )
    Begin
    {
        $Document = [System.Collections.ArrayList]@()

        if( ! $PSBoundParameters.Keys.Contains('WordCount') )
        {
            $WordCount = Get-Random -Minimum 10 -Maximum 201
        }

    }
    Process
    {
        # Create the word list for this document
        if($IncludeDiacritics)
        {
            $WordList = (1..($WordCount * 2) | 
                ForEach-Object -Process {New-NonsenseWord -IncludeDiacritics}) | 
                Select-Object -Unique |
                Select-Object -First $WordCount
        }else{
            $WordList = (1..($WordCount * 2) | 
                ForEach-Object -Process {New-NonsenseWord}) | 
                Select-Object -Unique |
                Select-Object -First $WordCount
        }
        # Decide how many paragraphs for this document
        $ParagraphCount = Get-Random -Minimum 3 -Maximum 21
        # Add the paragraphs to the document
        1..$ParagraphCount | ForEach-Object -Process {
            $Document.Add((New-NonsenseParagraph -WordList $WordList)) | Out-Null
        }
        # Add heading and subheading
        $HeadingWords = $WordList.Where({$_.Length -gt 5}) | Get-Random -Count 6
        $Heading = $HeadingWords[0].ToUpper()
        $SubHeading = ($HeadingWords[1..3] -join ' ').ToUpper()
        $BoldWord = $HeadingWords[4]
        $ItalicWord = $HeadingWords[5]
        
        
        # Style with markdown if designated
        if($Markdown)
        {
            # Insert heading and subheading
            $Document.Insert(0,'-----------')
            $Document.Insert(0,"`## $SubHeading")
            $Document.Insert(0,"`# $Heading")

            # Bold a word
            # italicize a word
            $count = 0
            $Document = $Document | ForEach-Object {
                $count++
                if($Count -gt 4)
                {
                    $_.Replace( $BoldWord, "__$($BoldWord)__" ).
                    Replace( $ItalicWord, "_$($ItalicWord)_" )
                }else{
                    $_
                }
            }
        }else{
            $Document.Insert(0," ")
            $Document.Insert(0,"$SubHeading")
            $Document.Insert(0," ")
            $Document.Insert(0,"$Heading")
        }

        # Output the file
        if($MarkDown)
        {
            $SplitPath = $Path.Split('.')
            $SplitPath[-1] = "md"
            $Path = $SplitPath -join '.'
            New-Item -Path $Path -Value ($Document -join "`n`n")
        }else{
            New-Item -Path $Path -Value ($Document -join "`n`n")
        }
    }
    End{}
}