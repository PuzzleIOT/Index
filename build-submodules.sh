INDEX_DIR=$PWD

echo "Building NetSwitch" && \
cd sketches/switch/NetSwitch && \
sh build-all.sh && \
cd $INDEX_DIR && \
echo "" && \

echo "Submodules were built successfully."
