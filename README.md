# MD Convert

MD convert is cli app in Ruby to convert Markdown file in HTML file

# Features :

# Title 1
## Title 2
### Title 3
#### Title 4 
##### Title 5
###### Title 6

Title Alt. 1
============

Title Alt. 2
------------

| col-line | col |
|-------|-------|
| line | case |

I love :smiley_cat: these creature are really **cute**.

### Code Block Resisting to injection :

```html
</code>
<script>
alert("Injection")
</script>
<code>
```

### Multiple language spported (via highlight.js) :

```js
console.log("Like JS")
```
```python
print("Or Python")
```
```cpp
#include <iostream>

int main()
{
    std::cout << "Or also c and c++ and also more then " << 100 <<  " other language" << std::endl;
    return 0;
}
```
