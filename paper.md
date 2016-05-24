---
title: "STUDENT PAPER: An Implementation of Parallel Bayesian Network Learning"
author:
  - Joseph Haddad
  - Anthony Deeter
  - Zhong-Hui Duan
  - Timothy W. O'Neil
tags: [Computing]
abstract: |
  this is a short abstract
references:
  - id: cooper
    title: A Bayesian method for the induction of probabilistic networks from data
    container-title: Machine Learning
    issued:
      year: 1992
    volume: 9
    issue: 4
    page: 309-347
    author:
      - given: Gregory F.
        family: Cooper
      - given: Edward
        family: Herskovits
    type: article-journal
  - id: sriram
    title: Predicting Gene Relations Using Bayesian Networks
    issued:
      year: 2011
    school: Department of Computer Science, University of Akron
    author:
      - given: Aparna
        family: Sriram
    type: thesis
  - id: pearl
    type: book
    title: Probabilistic inference in intelligent systems
    issued:
      year: 1998
    publisher: Morgan Kaufmann Publishers
    author:
      - given: Judea
        family: Pearl
  - id: korb
    type: book
    publisher: Chapman and Hall/CRC
    title: Bayesian artificial intelligence
    issued:
      year: 2003
    author:
      - given: Kevin
        family: Korb
      - given: Ann
        family: Nicholson
  - id: openmpapi
    type: webpage
    title: OpenMP Application Program Interface
    URL: http://www.openmp.org/mp-documents/OpenMP4.0.0.pdf
  - id: openmpboard
    type: webpage
    title: About the OpenMP ARB and OpenMP.org
    URL: http://openmp.org/wp/about-openmp/
---

**Describe the approach taken to solve the problem and project results.
Student papers should also reflect on the experience including such things as project organization, challenges, and solutions as well as the impact of the project on the students’ education and career outlook.**

# Introduction
Inferring relations among genes requires a significant amount of data.
Bayesian networks may be used to correlate this data and extract relationships among the genes. We do not know what this relationship is, but we know it has a high likelihood of existing.
These interactions can then be used to make testable hypotheses to determine how gene interactions influence life in organisms or humans. As a result, tests can be performed in the lab with more confidence and a reduced chance of wasting time and resources.
Bayesian network learning, however, is inherently slow because it is an NP-hard algorithm @cooper. To reduce the computational complexity, search space reduction algorithms may be utilized.
K2 is a great example of a search space reduction algorithm, but introduces a new problem. K2 restricts the parent hierarchy of genes within the graph, and thus introduces bias in the computed relations.
To achieve high confidence in the generated networks, an abundance of Bayesian networks need to be computed using random search space restrictions. These random search space restrictions remove the bias and provide results which can be interpreted at various levels of confidence @sriram.
By eliminating one problem and introducing another, we have enabled the ability of parallelization by requiring multiple units of work rather than just one faster unit of work.
Other authors describe parallel implementations that can increase the speed of Bayesian network learning (cite).
However, no libraries exist which compute multiple Bayesian networks concurrently.
This project examines the value of Bayesian network learning within a parallel environment in order to reduce the time needed to generate consensus networks using many topological inputs.
This examination is performed through implementation of said algorithm, utilizing various methods available such as OpenMP, MPI, and CUDA.

## Bayesian Networks
Bayesian networks capture qualitative relationships among variables within directed acyclic graphs (or DAGS).
Nodes within the DAG represent variables, and edges represent dependencies between said variables @korb @pearl.
Bayesian networks have a search space which grows exponentially when introducing new data and not placing restrictions on the structure of the network.
This complication can be overcome by using the K2 algorithm. The K2 algorithm reduces the computational cost of learning by imposing restraints on parent node connections via topological ordering @cooper.
Restricting the parent ordering, however, creates an issue of bias, which is inherent within a constraint-based search space reduction.
Sriram @sriram proposed a solution to this issue by creating a consensus network, or the combination of multiple Bayesian networks derived from several topological inputs.
Here, a topology refers to a hierarchical structure of parenthood that the K2 algorithm will utilize to reduce overall computational complexity while scoring data relationships.
To eliminate the bias created by these restraints, many randomly generated topologies are used. By increasing the number of topological inputs, the consensus network has a greater chance of reflecting the true nature of the gene interactions with higher levels of confidence.

## OpenMP
OpenMP, or (Open Multi-Processing), is a cross-platform, multilingual application programming interface (API) which enables parallel code portability. OpenMP consists of compiler directives and library functions which alter (parallelize) the execution of a program @openmpapi. In a nutshell, OpenMP provides means of distributing code (namely loops) across multiple threads.
An advisory board of top entities in computation controls its well-defined specification which can be implemented by various compilers to target specific system capabilities @openmpboard. This allows functionality on a wide range of processor architectures and operating systems.
The specification includes language-specific APIs, compiler directives, and standardized environment variables @openmpapi.
The model of OpenMP is comparable to the fork-join model, but provides convenience (cross-platform) features through compiler directives. These directives consist of, but are not limited to, barriers, critical regions, variable atomicity, shared/private memory, and reductions @openmpapi.

TODO: explain how OpenMP was applicable to the problem at hand at a high level and introspect the program layout.

## MPI

## CUDA

# Methodology
## Processors
## Nodes

# Results and Discussion
## Processors
## Nodes

# Conclusion

# Acknowledgments
This research is part of the Blue Waters sustained-petascale computing project, which is supported by the National Science Foundation (awards OCI-0725070 and ACI-1238993) and the state of Illinois. Blue Waters is a joint effort of the University of Illinois at Urbana-Champaign and its National Center for Supercomputing Applications.

# References
