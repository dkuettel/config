for arg in $@; do
    case $arg in

        (web-pdb)
            # needs pip3 install web-pdb in dockerfiles/nn-dev
            args+=(
                --env PYTHONBREAKPOINT='web_pdb.set_trace'
                -p 5555:5555
            )
            ;;

        (test)
            #args+=(--env TF_FORCE_GPU_ALLOW_GROWTH=true)
            cmd=(
                #with-log docker.log
                #python3 ~/toys/vim-python-tracebacks/vimfix.py -im
                python3 -m
                nn.flow.train test
                #--subset-random=100
                --subset-subsample=16
                #--num-refinement-steps=1
                --num-refinement-steps=10
                #--checkpoint=/efs/dkuettel/flow/tf2-training-2-smaller/variance/no-occlusion/noise-21/default/checkpoints/model-120000.h5
                #--checkpoint='/efs/dkuettel/flow/tf2-training-2-smaller/variance/no-occlusion/noise-21/topology/[(1,3)]/checkpoints/model-120000.h5'
                #--checkpoint='/efs/dkuettel/flow/tf2-training-2-smaller/variance/no-occlusion/noise-21/topology/[(64,7),(16,3),(1,3)]/checkpoints/model-120000.h5'
                #--checkpoint='/efs/dkuettel/flow/tf2-training-2-smaller/variance/no-occlusion/noise-21/topology/[(64,3),(64,3),(64,3),(1,3)]/checkpoints/model-120000.h5'
                #--checkpoint='/efs/dkuettel/flow/tf2-training-2-smaller/hit-50mm/classifier-now/pretrained-variance/first/checkpoints/model-120000.h5'
                #--checkpoint='/efs/dkuettel/flow/tf2-training-2-smaller/fixed-repr/classifier-now/0-vs-16to21/checkpoints/model-55000.h5'
                --checkpoint='/efs/dkuettel/flow/tf2-training-2-smaller/flow/192hx320w/checkpoints/model-120000.h5'
                --out-folder=.
                #--variance-threshold=5.0
                #--variance-visualization-count=100
                #--classifier=baseline
                #--objects=Mini_5Door.viewpoint_0000
                --resolution=192hx320w
            )
            ;;

        (test-27)
            cmd=(
                python3 ~/toys/vim-python-tracebacks/vimfix.py -im
                nn.flow.train test
                --out-folder=.
                --checkpoint=/efs/dkuettel/flow/tf2-training-2-smaller/test-port/1/stream-2-report/checkpoints/model-120000.h5
                --pose-solver=pnp
                --num-refinement-steps=3
            )
            ;;

        (test-he)
            cmd=(
                with-log docker.log
                python3 -m nn.flow.train test
                --subset-random=20
                --num-refinement-steps=3
                --checkpoint='/efs/dkuettel/flow/tf2-training-2-smaller/modern-2020-06-08/noise-21/objects-21/short/var-topology-[(64,3),(64,3),(64,3),(1,3)]/channel-scale-1.0/checkpoints/model-120000.h5'
                --out-folder=.
                --pose-solver=robust_weighted_ls
                --pose-solver-loss=arctan
            )
            ;;

        (plot-ratio-thresholds)
            cmd=(
                python3 -m nn.flow.evaluation plot-ratio-thresholds
                --base='/efs/dkuettel/flow/tf2-training-2-smaller/modern-2020-06-08/noise-21/objects-21/short/var-topology-[(64,3),(64,3),(64,3),(1,3)]/channel-scale-1.0/evals/cmetrics-grid-2'
                --thresholds=1.0,2.0,3.0,4.0,5.0,10.0,15.0,20.0
                --ref-count=3
            )
            ;;

        (plot-pose-covariance)
            cmd=(
                python3 -m nn.flow.evaluation plot-pose-covariance
                --base='/efs/dkuettel/flow/tf2-training-2-smaller/modern-2020-06-08/noise-21/objects-21/short/var-topology-[(64,3),(64,3),(64,3),(1,3)]/channel-scale-1.0/evals/cmetrics-2'
                --ref-count=3
            )
            ;;

        (plots)
            cmd=(
                with-log docker.log
                python3 -m nn.flow.train plot-variance-stats
                #--json-file='/efs/dkuettel/flow/tf2-training-2-smaller/variance/no-occlusion/noise-21/topology-channel-scale-1/[(64,7),(16,3),(1,3)]/evals/t-5.0/ref-1/variance-stats.json'
                --json-file='/efs/dkuettel/flow/tf2-training-2-smaller/variance/no-occlusion/noise-21/topology/[(64,7),(16,3),(1,3)]/evals/t-7.5/ref-1/variance-stats.json'
            )
            ;;

        (track)
            cmd=(
                python3 -m nn.flow.tracking track
                #--checkpoint='/efs/dkuettel/flow/tf2-training-2-smaller/modern-2020-06-08/noise-21/objects-5/short/var-topology-[(64,7),(16,3),(1,3)]/channel-scale-1.0/checkpoints/model-120000.h5'
                #--checkpoint='/efs/dkuettel/flow/tf2-training-2-smaller/modern-2020-06-08/noise-21/objects-5/long/var-topology-[(64,7),(16,3),(1,3)]/channel-scale-1.0/checkpoints/model-240000.h5'
                --checkpoint='/efs/dkuettel/flow/tf2-training-2-smaller/modern-2020-06-08/noise-21/objects-21/short/var-topology-[(64,3),(64,3),(64,3),(1,3)]/channel-scale-1.0/checkpoints/model-120000.h5'
                --testset=Volvogearbox/_3239213321/:VolvoGearbox.viewpoint_0000
                --model-name=VolvoGearbox.viewpoint_0000
                --noise=21
                --steps=1
                #--steps=2
                #--steps=3
                #--steps=5
                #--steps=10
                --variance
                --variance-threshold=15.0
                --no-show-invalid-poses
                --variance-pixel-fraction=0.3
                --robust-weighted-ls
            )
            ;;

        (cmd)
            cmd=(/bin/bash)
            ;;

        (write)
            cmd=(
                #with-log docker.log
                #python3 ~/toys/vim-python-tracebacks/vimfix.py -im
                python3 -m
                nn.flow config
                --seed=0
                --noise=21
                #--noise-model=keypie
                #--resolution=384hx384w
                #--resolution=384hx640w
                --resolution=192hx320w
                --hypo-style=normals
                --camera-style=recolored+background
                --camera-grayscale
                #--noise-distribution='0-vs-16to21'
                #--classifier-now-data-hit-ratio=0.5
                --negative-sample-ratio=0.4
                #write-dataset
                #--key=pose-refinement/flow/training-data/test-pose
                #--worker-id=1
                #--worker-count=2
                #--resume
                write-dataset-examples
                --count=100
            )
            ;;

        (train-flow)
            cmd=(
                #with-log docker.log  # doesnt work with debugging
                python3 -m nn.flow.train train
                --out-folder=.
                #--stream=pose-refinement/flow/training-data/hemanth/occlusions/curriculum-none/hypo-normals/camera-grayscale/384s/noise-21/0
                #--stream=pose-refinement/flow/training-data/test-pose
                --stream=pose-refinement/flow/training-data/dk/flow/noise-21-192hx230w
                #--predict-variance=1d
                --losses=regularization,flow
            )
            ;;

        (train-classifier)
            cmd=(
                with-tb
                #with-log docker.log  # doesnt work with debugging
                #python3 ~/toys/vim-python-tracebacks/vimfix.py -im
                python3 -m
                nn.flow.train train
                --out-folder=.
                #--stream=pose-refinement/flow/training-data/test-port/3
                #--stream=pose-refinement/flow/training-data/test-pose
                --stream=pose-refinement/flow/training-data/classifier-now/0-vs-16to21
                --channel-scale=0.5
                --batchnorm
                --no-batchnorm-predict-flow
                --weight-decay=0.0002
                --predict-variance=1d
                --variance-1d-topology='[(64,3),(64,3),(64,3),(1,3)]'
                --variance-1d-loss=ll-2d-gaussian
                --weights-from=/efs/dkuettel/flow/tf2-training-2-smaller/grayscale-stream/training/variance/checkpoints/model-120000.h5

                --predict-classifier-now
                --classifier-now-topology=first
                --losses=regularization,classifier_now
                --trainable=classifier_now

                #--predict-classifier-next
                #--classifier-next-topology=first
                #--losses=regularization,classifier_next
                #--trainable=classifier_next

                #--predict-classifier-improve
                #--losses=regularization,classifier_improve
                #--trainable=classifier_improve
            )
            ;;

        (train-classifier-foreground)
            cmd=(
                #with-tb
                #with-log docker.log  # doesnt work with debugging
                #python3 ~/toys/vim-python-tracebacks/vimfix.py -im
                python3 -m
                nn.flow.train train
                --out-folder=.
                --stream=pose-refinement/flow/training-data/hemanth/no-object/noise-21
                --channel-scale=0.5
                --batchnorm
                --no-batchnorm-predict-flow
                --weight-decay=0.0002
                --predict-variance=1d
                --variance-1d-topology='[(64,3),(64,3),(64,3),(1,3)]'
                --variance-1d-loss=ll-2d-gaussian
                --weights-from=/efs/dkuettel/flow/tf2-training-2-smaller/grayscale-stream/training/variance/checkpoints/model-120000.h5

                --predict-classifier-foreground
                --losses=regularization,classifier_foreground
                --trainable=classifier_foreground
            )
            ;;

        (test-pr)
            cmd=(
                #with-log docker.log  # doesnt work with debugging
                #python3 ~/toys/vim-python-tracebacks/vimfix.py -im
                python3 -m
                nn.flow.train train
                --out-folder=.
                --stream=pose-refinement/flow/training-data/test-port/3
                --channel-scale=0.5
                --batchnorm
                --no-batchnorm-predict-flow
                --weight-decay=0.0002
                --predict-variance=1d
                --variance-1d-topology='[(64,3),(64,3),(64,3),(1,3)]'
                --variance-1d-loss=ll-2d-gaussian
                --weights-from=/efs/dkuettel/flow/tf2-training-2-smaller/hit-50mm/classifier-now/pretrained-variance/first/checkpoints/model-120000.h5

                --predict-classifier-now
                --classifier-now-topology=first
                --losses=regularization,classifier_now
                --trainable=''

                #--predict-classifier-next
                #--classifier-next-topology=off-scale-6
                #--losses=regularization,classifier_next
                #--trainable=classifier_next
            )
            ;;

        (tflite)
            cmd=(
                python3 -m nn.flow.export
                tflite
                --checkpoint=/efs/dkuettel/flow/tf2-training-2-smaller/fixed-repr/classifier-now/0-vs-16to21/checkpoints/model-55000.h5
                --out-folder=/efs/dkuettel/flow/tf2-training-2-smaller/fixed-repr/classifier-now/0-vs-16to21
                #--resolution=192hx320w
                --resolution=384hx384w
            )
            ;;

        (sdk)
            cmd=(
                python3 -m nn.flow.export
                create-sdk-dataset
                --output-dir=/efs/dkuettel/flow/tf2-training-2-smaller/fixed-repr/classifier-now/0-vs-16to21/export
                --input-channels=4
                --output-flow-tensor=Identity_2
                --output-flow-cov-tensor=Identity_7
                --output-classifier-now-tensor=Identity
                --output-classifier-next-tensor=Identity
                --checkpoint=/efs/dkuettel/flow/tf2-training-2-smaller/fixed-repr/classifier-now/0-vs-16to21/checkpoints/model-55000.h5
                #--input-resolution=?
            )
            ;;

        (*)
            echo 'unknown value:' $arg
            exit 1
            ;;

    esac
done
