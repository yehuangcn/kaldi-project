#!/bin/bash
cd /home/nlpserver/zzilong/kaldi/egs/supermarket-product
. ./path.sh
( echo '#' Running on `hostname`
  echo '#' Started at `date`
  echo -n '# '; cat <<EOF
nnet-shuffle-egs --buffer-size=5000 --srand=113 ark:exp/nnet4a/egs/egs.${SGE_TASK_ID}.5.ark ark:- | nnet-train-parallel --num-threads=8 --minibatch-size=128 --srand=113 exp/nnet4a/113.mdl ark:- exp/nnet4a/114.${SGE_TASK_ID}.mdl 
EOF
) >exp/nnet4a/log/train.113.$SGE_TASK_ID.log
time1=`date +"%s"`
 ( nnet-shuffle-egs --buffer-size=5000 --srand=113 ark:exp/nnet4a/egs/egs.${SGE_TASK_ID}.5.ark ark:- | nnet-train-parallel --num-threads=8 --minibatch-size=128 --srand=113 exp/nnet4a/113.mdl ark:- exp/nnet4a/114.${SGE_TASK_ID}.mdl  ) 2>>exp/nnet4a/log/train.113.$SGE_TASK_ID.log >>exp/nnet4a/log/train.113.$SGE_TASK_ID.log
ret=$?
time2=`date +"%s"`
echo '#' Accounting: time=$(($time2-$time1)) threads=1 >>exp/nnet4a/log/train.113.$SGE_TASK_ID.log
echo '#' Finished at `date` with status $ret >>exp/nnet4a/log/train.113.$SGE_TASK_ID.log
[ $ret -eq 137 ] && exit 100;
touch exp/nnet4a/q/done.1086.$SGE_TASK_ID
exit $[$ret ? 1 : 0]
## submitted with:
# qsub -v PATH -cwd -S /bin/bash -j y -l arch=*64* -o exp/nnet4a/q/train.113.log -l mem_free=10G,ram_free=2G,arch=*64  -pe smp 4 -l mem_free=1G,ram_free=1G  -t 1:8 /home/nlpserver/zzilong/kaldi/egs/supermarket-product/exp/nnet4a/q/train.113.sh >>exp/nnet4a/q/train.113.log 2>&1
