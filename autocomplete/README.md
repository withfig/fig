# Want autocomplete?

Please refer to our public [withfig/autocomplete](https://github.com/withfig/autocomplete) repo for more details.

### Get up to date completion scripts

Run the following:

```
# Make the autocomplete folder where Fig looks for completion specs. Cd into it
mkdir -p ~/.fig/autocomplete; cd $_

# Download all the files in the specs folder of this repo
curl https://codeload.github.com/withfig/autocompelte/tar.gz/master | \
tar -xz --strip=2 autocomplete-master/specs
```