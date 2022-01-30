#!/bin/env bash
echo "Deprecated: Use $(dmccbs build) instead"

# create necessary project folders if they don't exist
mkdir -p ./src ./include ./lib ./src ./.obj_cache ./bin ./buildflags
test ! -f ./buildflags/preprocessor.sh && echo "#!/bin/env sh" >./buildflags/preprocessor.sh && chmod +x ./buildflags/preprocessor.sh
test ! -f ./buildflags/linker.sh && echo "#!/bin/env sh" >./buildflags/linker.sh && chmod +x ./buildflags/linker.sh

# Find all source files in ./src
# src_files=$(find ./src -name '*.cc')
readarray -t src_files < <(find ./src -name '*.cc')

# run c preprocessor on each source file
# then compute the hash
# and compile the object if the hash is not in ./.obj_store
hashes=()

# iterate over all source files
for src_file in "${src_files[@]}"; do
    # use cc (c preprocessor) to preprocess the source file from *.cc to *.cc.pp
    clang++ -E -I./include/ $(./buildflags/preprocessor.sh) $src_file >$src_file.pp

    # Hash the processed file and check if its already in ./.obj_cache
    hash=$(sha256sum $src_file.pp | awk '{ print $1 }')
    obj_file=./.obj_cache/$hash.o

    # Add hash to the list of hashes
    [[ -n $DMC_DEBUG ]] && echo "Adding $src_file $hash"
    hashes+=(./.obj_cache/$hash.o)

    # if the object file is not in ./.obj_cache, compile it
    if test ! -f $obj_file; then

        [[ -n $DMC_DEBUG ]] && echo "Compiling $src_file"

        clang++ -I./include/ $(./buildflags/preprocessor.sh) -c $src_file -o $obj_file &
    fi

done

wait

# echo $hashes
[[ -n $DMC_DEBUG ]] && echo "Linking "${hashes[@]}""

# Compile together all the object files in $hashes
clang++ -fuse-ld=mold -L./lib/ $(./buildflags/preprocessor.sh) -flto -o ./bin/main "${hashes[@]}" $(./buildflags/linker.sh)

rm ./src/**.cc.pp
