Kustomize has built-in transformers for:

namespace
labels
name prefix
annotations
image replacement



Be careful: labels can affect selectors, so make sure the Service still reaches the Pods.

