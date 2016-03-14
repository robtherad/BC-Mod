// Public
PREP(addArea); // Call to add boundary. Checks inputs to ensure no errors. Calls createArea.
PREP(removeArea); // Call to remove boundary.
PREP(enableBoundaries); // Call to re-enable boundaries

// Internal
PREP(checkBoundsPFH); // Client PFH that checks player pos against all boundaries. Also checks to see if exit variable has been defined.
PREP(createArea); // Creates boundaries with given variables.
PREP(enableBoundariesPFH); // Makes sure boundary script isn't already running, then starts it back up again.
PREP(multiPosCheck);
PREP(singlePosCheck);