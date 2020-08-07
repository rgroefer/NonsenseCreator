# NonsenseCreator

## Iron Scripter Challenge

Module to create __nonsense__ words, sentences, paragraphs, and documents.  Allows for adding markdown formatting as well. Challenge at https://ironscripter.us/a-powershell-nonsense-challenge/

### Solution Goals
- Generate a word that has a 75% chance of alternating from vowel to consonant at each letter.
- Generate a sentence, paragraph, or document using words with the aforementioned function.
- Generate markdown formatted document.
- Include diacritics option
- Include word length, sentence length, paragraph length, and document length options

### Solution method
Use object classes for vowel, consonant, special characters, and connecting punctuation.  The nonsensical words are generated with the letters having a 75% chance of alternating from vowel to consonant and back to flow better if actually read.  When creating a document, first generate a word list with nearly twice as many words as the word count given or the word count randomly chosen by the function.  This will cause the document to repeat words, which I believe is easier on the eyes at a glance and makes the document build faster.

#### Example Word List Code

```powershell
    $WordList = (1..($WordCount * 2) | 
    ForEach-Object -Process {New-NonsenseWord -IncludeDiacritics}) | 
    Select-Object -Unique |
    Select-Object -First $WordCount
```

#### Example Object Class

```powershell
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
```

### Functions
- New-NonsenseWord
-- Uses the object class types to generate random words
-- Offers length and diacritics options
- New-NonsenseSentence
-- Calls the New-NonsenseWord function
-- Offers length, diacritics, and word list options
- New-NonsenseParagraph
-- Calls the New-NonsenseSentence function
-- Offers sentence count, diacritics, and word list options
- New-NonsenseDocument
-- Requires a path for the output file
-- Offers diacritics, word count, and markdown optiosn

### Object Classes
- Vowel
- Consonant
- Punctuation
- SpecialCharacter