# workflow_dakota_3Delbow
Dakota + 3D Elbow in a very generalized way

dakota dakota.swift to run DOE
Edit openfoam/sweepParams.run to specify range of DOE

dakota dakota_surr.swift to run surrogate model. If DOE runs before surrgate model, some points may be extracted from DOE results.

Note: coaster worker number should > (1 + dakota_concurency) to avoid deadlock as such an amount of idealing swfit tasks are created for management purpose. The suggested worker number is (1 + dakota_concurency + number_of_cores)
