[hashtable]$phoneticCode = @{
    A = "Alpha"
    B = "Bravo"
    C = "Charlie"
    D = "Delta"
    E = "Echo"
    F = "Foxtrot"
    G = "Golf"
    H = "Hotel"
    I = "India"
    J = "Juliet"
    K = "Kilo"
    L = "Lima"
    M = "Mike"
    N = "November"
    O = "Oscar"
    P = "Papa"
    Q = "Quebec"
    R = "Romeo"
    S = "Sierra"
    T = "Tango"
    U = "Uniform"
    V = "Victor"
    W = "Whiskey"
    X = "X-ray"
    Y = "Yankee"
    Z = "Zulu"
}

Write-Host "Welcome to phonetic-code quiz!"
[int]$correctPoint = 0
[int]$totalCount = 0
[int]$currentPoint = 0
while ($true) {
    
    [char[]]$alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    [string]$randomLetter = Get-Random -InputObject ($alphabets)
    
    [string]$correctAnswer = $phoneticCode[$randomLetter]
    
    $userAnswer = Read-Host -Prompt "What is the phonetic code for ${randomLetter} ?"
    
    
    $totalcount ++
    if ($userAnswer -eq $correctAnswer) {
        Write-Host "Correct!" -ForegroundColor Green
        $correctPoint ++
        $currentPoint ++
    } else {
        Write-Host "Incorrect. The correct answer is " -NoNewline
        Write-Host "$correctAnswer." -ForegroundColor Red
        $currentPoint = 0
    }
    Write-Host "Consrecutive correct is " -NoNewline
    Write-Host "${currentPoint}" -ForegroundColor Cyan

    $rate = [Math]::Round($correctPoint * 100 / $totalCount, 2)
    Write-Host "Correct answer rate is " -NoNewline
    Write-Host "${rate}%." -ForegroundColor Magenta
}

Write-Host "Exiting quiz."
