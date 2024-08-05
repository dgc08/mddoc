# MdDoc Markdown -> Source Files compiler

This is just a quick project, nothing too fancy (but I am required to write documentation or the purpose would be defeated).

This file is README/Documentation and source file in one. The purpose of this little program is to convert Markdown files to source files, by commenting everything except for the code blocks.

You can write your source files in Markdown files with codeblocks. Run all your Markdown files through this program, and the normal source file will be produced, with all non-code turned to comments. Take a look at the Makefile for examples on how to automate that.

## Compiling
You will need the Glasgow Haskell Compiler to compile this program.
Run 
`make mddoc`
to build the program.
As long as the output source file is present and recent enough, this command should work. If not, you can try to use 
`make bootstrap`
before that to make a bootstrap executable as long as a source file exists. Make sure to run the real build command after that once again.

The output of this program (the Haskell file) is included in Git for it to be bootstrapped.

# The Code itself 
Imports and helper functions
```
import System.Directory.Internal.Prelude (getArgs)
import Data.List (intercalate)


-- Split a string by the specified delimiter
splitBy :: Char -> String -> [String]
splitBy _ "" = [""]
splitBy delim str = case break (== delim) str of
    (prefix, []) -> [prefix]
    (prefix, _:suffix) -> prefix : splitBy delim suffix

```
The 'compiler' itself ahs two stages which switch between itself:
`commentText` comments the markdown text. If a new code block is detected, it switches to
`parseCodeBlock`, which reads in the code unchanged, unti the code block ends. Then it switches back.
```
parseCodeDoc :: String -> String -> String -> String -> String
parseCodeDoc input commentPrefix codeBegin codeEnd = unlines $ commentText $ lines input
  where
    parseCodeBlock :: [String] -> [String]
    parseCodeBlock [] = []
    parseCodeBlock (x:xs)
      | codeEnd == x = commentText xs
      | otherwise    = x : parseCodeBlock xs
    commentText :: [String] -> [String]
    commentText (x:xs)
      | codeBegin == x = parseCodeBlock xs
      | otherwise      = (commentPrefix ++ " " ++ x) : commentText xs
    commentText [] = []

```
Take two args: `mddoc [file] [commentSyntax]`
For example for this file `mddoc mddoc.hs.md '--'`
```
main :: IO()
main = do
  args <- getArgs
  if length args /= 2
    then putStrLn "Usage: mddoc {inputfile} {commentSyntax}"
  else do
    let (filename : comm : _) = args
    input <- readFile filename
```
Parse the code (`input`) with specified comment syntax and the markdown code block syntax
```
    let output = parseCodeDoc input comm "```" "```"
```
This will split the input filename, split it by '.' and cut off the last extension. That will be the new output filename
```
    let outputFile = intercalate "." $ take (length (splitBy '.' filename)-1) $ splitBy '.' filename

    writeFile outputFile output
```
