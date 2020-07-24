class Vowel
{
    [char]$Letter
    hidden [int]$Int
    hidden [bool]$Uppercase
    hidden [int[]]$PossibleInts = 97,101,105,111,117,121

    Vowel()
    {
        $this.Letter = [char]$($this.PossibleInts | Get-Random)
    }
}
class Consonant
{
    [char]$Letter
    hidden [int]$Int
    hidden [int[]]$PossibleInts = 98,99,100,102,103,104,106,107,108,109,110,112,113,114,115,116,118,119,120,121,122

    Consonant()
    {
        $this.Letter = [char]$($this.PossibleInts | Get-Random)
    }
}
class Punctuation
{
    [char]$Letter
    hidden [int]$Int
    hidden [bool]$isConnectorType

    Punctuation([bool]$isConnectorType)
    {
        if($isConnectorType)
        {
            $RandomNumber = 1..10 | Get-Random
            if ($RandomNumber -le 5)
            {
                $this.Letter = [char]44
            }
            elseif ($RandomNumber -in (6..9))
            {
                $this.Letter = [char]59
            }
            else
            {
                $this.Letter = [char]58
            }
        }
        else
        {
            if((1..10 | Get-Random) -gt 9)
            {
                if((1..2 | Get-Random) -eq 1)
                {
                    $this.Letter = [char]33
                }
                else
                {
                    $this.Letter = [char]63
                }
            }
            else
            {
                $this.Letter = [char]46
            }
        }
        $this.isConnectorType = $isConnectorType
    }
}
class SpecialCharacter
{
    [char]$Letter
    hidden [int]$Int

    SpecialCharacter([string]$VowelGiven)
    {
        switch($VowelGiven)
        {
            "a" {$this.Letter = [char]$(Get-Random -Minimum 224 -Maximum 230); break}
            "e" {$this.Letter = [char]$(Get-Random -Minimum 232 -Maximum 236); break}
            "i" {$this.Letter = [char]$(Get-Random -Minimum 236 -Maximum 240); break}
            "o" {$this.Letter = [char]$(Get-Random -Minimum 242 -Maximum 247); break}
            "u" {$this.Letter = [char]$(Get-Random -Minimum 249 -Maximum 253); break}
            "y" {$this.Letter = [char]$(Get-Random -Minimum 253 -Maximum 256); break}
        }
        
        $this.Letter = [char]$this.Letter.ToString()
    }
}