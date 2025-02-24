---
title: "SVD Visualisation"
excerpt: "An interactive visualisation of Singular Value Decomposition."
header:
  image: "/assets/images/svd-visualisation-preview-hero.jpg"
  teaser: "/assets/images/svd-visualisation-preview.jpg"
layout: single
---

The project consists of a web application that allows users to input a matrix, compute its SVD, and visualize the resulting matrices (U, Σ, and V) in 3D space. The visualization is implemented using Three.js.

# Technical Analysis
## Computing ( A^T A )
The first step in computing the SVD is to calculate the matrix product \( A^T A \).

```javascript
const ATA = Array(m).fill(0).map(() => Array(m).fill(0));
for (let i = 0; i < m; i++) {
   for (let j = 0; j < m; j++) {
       for (let k = 0; k < n; k++) {
           ATA[i][j] += matrix[k][i] * matrix[k][j];
       }
   }
}
```

This code initializes an \( m \times m \) matrix filled with zeros and then computes the dot product of the columns of the original matrix to populate \( A^T A \).

## Computing Eigenvalues and Eigenvectors
Next, we compute the eigenvalues and eigenvectors of \( A^T A \). This is done using the `computeEigen` function, which handles both 2x2 and 3x3 matrices. Here’s the 3x3 version of the algorithm:

```javascript
// Compute eigenvalues and eigenvectors for 3x3 matrix
const a = matrix[0][0];
const b = matrix[0][1];
const c = matrix[0][2];
const d = matrix[1][0];
const e = matrix[1][1];
const f = matrix[1][2];
const g = matrix[2][0];
const h = matrix[2][1];
const i = matrix[2][2];

// Characteristic polynomial coefficients
const p1 = -1;
const p2 = a + e + i;
const p3 = -(a * e + a * i + e * i - b * d - c * g - f * h);
const p4 = a * e * i + b * f * g + c * d * h - c * e * g - b * d * i - a * f * h;

// Solve cubic equation for eigenvalues
const roots = solveCubic(p1, p2, p3, p4);
const eigenvalues = roots.map(root => root.real);

// Compute eigenvectors
const eigenvectors = eigenvalues.map(lambda => {
    const A = [
        [a - lambda, b, c],
        [d, e - lambda, f],
        [g, h, i - lambda]
    ];
    const eigenvector = nullSpace(A);
    return eigenvector;
});

// Normalize eigenvectors
for (let j = 0; j < eigenvectors.length; j++) {
    let norm = 0;
    for (let i = 0; i < eigenvectors[j].length; i++) {
        norm += eigenvectors[j][i] * eigenvectors[j][i];
    }
    norm = Math.sqrt(norm);
    for (let i = 0; i < eigenvectors[j].length; i++) {
        eigenvectors[j][i] /= norm;
    }
}

const transposedEigenvectors = transpose(eigenvectors);

return { eigenvalues, eigenvectors: transposedEigenvectors };
```

## Constructing the \( U \) Matrix
The \( U \) matrix is computed using the equation \( U = \frac{1}{\sigma} A V \):

```javascript
const U = Array(n).fill(0).map(() => Array(m).fill(0));
for (let j = 0; j < m; j++) {
   for (let i = 0; i < n; i++) {
       for (let k = 0; k < m; k++) {
           if (S[j][j] !== 0) {
               U[i][j] += matrix[i][k] * V[k][j] / S[j][j];
           }
       }
   }
}
```


This code iterates through the elements of the matrices and computes each element of \( U \) by multiplying the corresponding elements of \( A \) and \( V \), and dividing by the singular values.

## Normalizing the ( U ) Matrix
Finally, the ( U ) matrix is normalized to ensure that its columns are unit vectors:

```javascript
for (let j = 0; j < m; j++) {
	let norm = 0;
	for (let i = 0; i < n; i++) {
    	norm += U[i][j] * U[i][j];
	}
	norm = Math.sqrt(norm);
	for (let i = 0; i < n; i++) {
    	U[i][j] /= norm;
	}
}
```

This code computes the norm of each column and divides each element by the norm to normalize the columns.


<a href="https://kujal.github.io/svd-visualisation/" class="btn btn--primary">Open Project</a>