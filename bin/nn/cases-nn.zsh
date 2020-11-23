for arg in $@; do
    case $arg in

        (web-pdb)
            # needs pip3 install web-pdb in dockerfiles/nn-dev
            args+=(
                --env PYTHONBREAKPOINT='web_pdb.set_trace'
                -p 5555:5555
            )
            ;;

        (train-mtar)
            cmd=(
                with-log docker.log
                python3 -m nn.mtar360.eap1 train
                    --config-folder=s3://e2e-benchmarking/training/zurich-all-set/recolored
                    --out-folder=.
                    #--testsets=mtar360/all/recolored/v2
                    mtar
                    --short-training=True
            )
            ;;

        (viewer)
            cmd=(
                python3 -m nn.rendering.viewer
                trainset
                #s3://e2e-benchmarking/training/AssemblyStates/lego-lighthouse-31051/all-shaded
                s3://e2e-benchmarking/training/AssemblyStates/delonghi-coffee-machine/all-recolored
            )
            ;;

        (bash)
            cmd=(bash)
            ;;

        (ipython)
            cmd=(ipython3)
            ;;

        (ci)
            exit 1  # todo
            #args+=(--workdir=/xp/src/nn)
            #cmd=(pytest -v -s tests)
            # note -m "not slow" seems to include slow?! not sure
            # note, on kubernetes would be 'xpman start-pytest --output-folder=some/path'
            # note: pytest -vv -k "train_eval_mtar360" to run specific test when you are trying to fix it
            #args+=(--workdir=/xp/src/nn/tests)
            #cmd=(pytest -v -s)

            #cmd=(pytest -vv -k 'test_low_recognition_quality')
            #cmd=(python3 -m pytest -vv -k 'test_template_parsing')

            #args+=(--workdir=/xp/src/nn/tests)
            #cmd=(pytest -vv 'mtar360/test_errors.py::test_low_recognition_quality[mode_params1]')
            ;;

        (variations)
            # run mt360 with audi model(s)
            cmd=(
                with-log docker.log
                python3 -m nn.mtar360.eap1 train
                    #--config-folder=s3://e2e-benchmarking/training/AudiA4Multiview/recoloredWithDoors4EP
                    #--config-folder=s3://e2e-benchmarking/training/AudiA4Multiview/simplified
                    --config-folder=s3://e2e-benchmarking/training/AudiA4Multiview/dkuettel-audi-variations
                    --out-folder=.
                    #--testsets=audi_a4/interior_closeups/converted_InsideGeneralInspection:09c12a99bf5f426a95eed400e89e8946:cls_gt_4_EP
                    mt360
                    --short-training=True
                    --coarse
                    --assemblies=09c12a99bf5f426a95eed400e89e8946.viewpoint_0000,09c12a99bf5f426a95eed400e89e8947.viewpoint_0000
                    #--representative=one
            )
            ;;

        (cluster)
            cmd=(
                #with-log docker.log
                python3 -m nn.mtar360.eap1 state-clustering
                    --yaml-config=/xp/src/nn/python/nn/mtar360/eap1/mt360-config-template.yaml
                    #--trainset=s3://e2e-benchmarking/training/AssemblyStates/lego-lighthouse-31051/all-shaded
                    #--trainset=s3://e2e-benchmarking/training/AssemblyStates/delonghi-coffee-machine/all-recolored
                    #--trainset=s3://deep-learning-data/data/sets/SigmaTile/config
                    --trainset=s3://deep-learning-data/data/sets/SigmaTile-ManyStates/279/config
                    #--assemblies=lighthouse-100.viewpoint_front,lighthouse-110.viewpoint_front,lighthouse-160.viewpoint_front,lighthouse-180.viewpoint_front
                    --n-viewpoints=1000
                    --prune
                    --output-dir=.
            )
            ;;

        (cluster-eval)
            cmd=(
                #with-log docker.log
                python3 -m nn.mtar360.eap1 evaluate-mtar360c-clustered
                    --testsets=AssemblyStates/lego-lighthouse-31051/v2/lighthouse-050-01:lighthouse-050.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-050-02:lighthouse-050.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-060-01:lighthouse-060.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-060-02:lighthouse-060.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-070-01:lighthouse-070.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-070-02:lighthouse-070.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-080-01:lighthouse-080.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-080-02:lighthouse-080.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-090-01:lighthouse-090.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-090-02:lighthouse-090.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-100-01:lighthouse-100.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-100-02:lighthouse-100.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-110-01:lighthouse-110.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-110-02:lighthouse-110.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-120-01:lighthouse-120.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-120-02:lighthouse-120.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-130-01:lighthouse-130.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-130-02:lighthouse-130.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-140-01:lighthouse-140.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-140-02:lighthouse-140.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-150-01:lighthouse-150.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-150-02:lighthouse-150.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-160-01:lighthouse-160.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-160-02:lighthouse-160.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-170-01:lighthouse-170.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-170-02:lighthouse-170.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-180-01:lighthouse-180.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-180-02:lighthouse-180.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-200-01:lighthouse-200.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-200-02:lighthouse-200.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-210-01:lighthouse-210.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-210-02:lighthouse-210.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-220-01:lighthouse-220.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-220-02:lighthouse-220.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-230-01:lighthouse-230.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-230-02:lighthouse-230.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-240-01:lighthouse-240.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-240-02:lighthouse-240.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-250-01:lighthouse-250.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-250-02:lighthouse-250.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-260-01:lighthouse-260.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-260-02:lighthouse-260.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-270-01:lighthouse-270.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-270-02:lighthouse-270.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-280-01:lighthouse-280.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-280-02:lighthouse-280.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-290-01:lighthouse-290.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-290-02:lighthouse-290.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-300-01:lighthouse-300.viewpoint_front,AssemblyStates/lego-lighthouse-31051/v2/lighthouse-300-02:lighthouse-300.viewpoint_front
                    --output-dir=.
                    --cls-model-dir=/efs/dkuettel/clustering/MtXp/9f8c0f0ddc5946e1aaf78fdec0a1f73f/nn-model-export
                    --named-pe-model-dir lighthouse-010.viewpoint_front /efs/dkuettel/clustering/MtXp/e387e097180244b8b27d1d960939b008/nn-model-export
                    --named-pe-model-dir lighthouse-020.viewpoint_front /efs/dkuettel/clustering/MtXp/e387e097180244b8b27d1d960939b008/nn-model-export
                    --named-pe-model-dir lighthouse-030.viewpoint_front /efs/dkuettel/clustering/MtXp/a5679b0ba09047379b81af75402c051c/nn-model-export
                    --named-pe-model-dir lighthouse-040.viewpoint_front /efs/dkuettel/clustering/MtXp/a5679b0ba09047379b81af75402c051c/nn-model-export
                    --named-pe-model-dir lighthouse-050.viewpoint_front /efs/dkuettel/clustering/MtXp/57c6926ea5dd4f7eb7192a334549c84d/nn-model-export
                    --named-pe-model-dir lighthouse-060.viewpoint_front /efs/dkuettel/clustering/MtXp/57c6926ea5dd4f7eb7192a334549c84d/nn-model-export
                    --named-pe-model-dir lighthouse-070.viewpoint_front /efs/dkuettel/clustering/MtXp/8d54f955ff8042f993fa5e2a985ebc76/nn-model-export
                    --named-pe-model-dir lighthouse-080.viewpoint_front /efs/dkuettel/clustering/MtXp/8d54f955ff8042f993fa5e2a985ebc76/nn-model-export
                    --named-pe-model-dir lighthouse-090.viewpoint_front /efs/dkuettel/clustering/MtXp/8d54f955ff8042f993fa5e2a985ebc76/nn-model-export
                    --named-pe-model-dir lighthouse-100.viewpoint_front /efs/dkuettel/clustering/MtXp/8d54f955ff8042f993fa5e2a985ebc76/nn-model-export
                    --named-pe-model-dir lighthouse-110.viewpoint_front /efs/dkuettel/clustering/MtXp/8d54f955ff8042f993fa5e2a985ebc76/nn-model-export
                    --named-pe-model-dir lighthouse-120.viewpoint_front /efs/dkuettel/clustering/MtXp/8d54f955ff8042f993fa5e2a985ebc76/nn-model-export
                    --named-pe-model-dir lighthouse-130.viewpoint_front /efs/dkuettel/clustering/MtXp/8d54f955ff8042f993fa5e2a985ebc76/nn-model-export
                    --named-pe-model-dir lighthouse-140.viewpoint_front /efs/dkuettel/clustering/MtXp/8d54f955ff8042f993fa5e2a985ebc76/nn-model-export
                    --named-pe-model-dir lighthouse-150.viewpoint_front /efs/dkuettel/clustering/MtXp/8dffc44d868447a785a500b2e02eac2d/nn-model-export
                    --named-pe-model-dir lighthouse-160.viewpoint_front /efs/dkuettel/clustering/MtXp/8dffc44d868447a785a500b2e02eac2d/nn-model-export
                    --named-pe-model-dir lighthouse-170.viewpoint_front /efs/dkuettel/clustering/MtXp/8dffc44d868447a785a500b2e02eac2d/nn-model-export
                    --named-pe-model-dir lighthouse-180.viewpoint_front /efs/dkuettel/clustering/MtXp/16d1794212c8471182e8c823f896a336/nn-model-export
                    --named-pe-model-dir lighthouse-190.viewpoint_front /efs/dkuettel/clustering/MtXp/16d1794212c8471182e8c823f896a336/nn-model-export
                    --named-pe-model-dir lighthouse-200.viewpoint_front /efs/dkuettel/clustering/MtXp/cee034c112af418cb423bb622369e599/nn-model-export
                    --named-pe-model-dir lighthouse-210.viewpoint_front /efs/dkuettel/clustering/MtXp/cee034c112af418cb423bb622369e599/nn-model-export
                    --named-pe-model-dir lighthouse-220.viewpoint_front /efs/dkuettel/clustering/MtXp/cee034c112af418cb423bb622369e599/nn-model-export
                    --named-pe-model-dir lighthouse-230.viewpoint_front /efs/dkuettel/clustering/MtXp/cee034c112af418cb423bb622369e599/nn-model-export
                    --named-pe-model-dir lighthouse-240.viewpoint_front /efs/dkuettel/clustering/MtXp/cee034c112af418cb423bb622369e599/nn-model-export
                    --named-pe-model-dir lighthouse-250.viewpoint_front /efs/dkuettel/clustering/MtXp/054f8c1401ec4a2dba2a0bed7c482c88/nn-model-export
                    --named-pe-model-dir lighthouse-260.viewpoint_front /efs/dkuettel/clustering/MtXp/054f8c1401ec4a2dba2a0bed7c482c88/nn-model-export
                    --named-pe-model-dir lighthouse-270.viewpoint_front /efs/dkuettel/clustering/MtXp/054f8c1401ec4a2dba2a0bed7c482c88/nn-model-export
                    --named-pe-model-dir lighthouse-280.viewpoint_front /efs/dkuettel/clustering/MtXp/275dc0bb6c3a4b58a4bb03dc95d3ade8/nn-model-export
                    --named-pe-model-dir lighthouse-290.viewpoint_front /efs/dkuettel/clustering/MtXp/792ab90740504603b98483229e99b2cf/nn-model-export
                    --named-pe-model-dir lighthouse-300.viewpoint_front /efs/dkuettel/clustering/MtXp/792ab90740504603b98483229e99b2cf/nn-model-export
                    --named-pe-model-dir lighthouse-310.viewpoint_front /efs/dkuettel/clustering/MtXp/792ab90740504603b98483229e99b2cf/nn-model-export
            )
            ;;

        (export)
            f=/efs/dkuettel/clustering/sigma_tile/MtXp/4691606d654341b98f04e5e2e15b4fc4
            cmd=(
                python3 -m nn.mtar360.eap1 export-network
                    --template-path=$f/template.yaml
                    --style-path=$f/style.yaml
                    --model-path=$f/recalibrated_model.h5
                    --output-dir=$f/export-stefan
            )
            ;;

        (*)
            echo 'unknown value:' $arg
            exit 1
            ;;

    esac
done
