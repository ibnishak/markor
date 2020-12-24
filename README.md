Fork of [markor](https://github.com/gsantner/markor) with personal mods.

## Major changes
- Button to convert selected text to a markdown link. The link part is slugified. eg:
```
    This is an apple ----> [This is an apple](this-is-an-apple) 
```
- Creation of non-existance files upon clicking links.
```
[This is an apple](this-is-an-apple)  ----> this-is-an-apple.md with the text "# This Is An Apple"
```
- Attributes and Definition list felxmark plugins
- Modified CSS
- If there a corresponding YAML file in the `.meta` subdirectory, its contents will be shown in preview mode at the bottom of file.
  eg: If there exists `.meta/this-is-an-apple.yaml`, its contents will be shown in `this-is-an-apple.md`
- Line breaks are same in editor mode and preview mode

## Minor changes
- Gradle distribution upgraded to 6.3
- Changes in the way H1 button works. It merely adds more and more #s to the begining of line.