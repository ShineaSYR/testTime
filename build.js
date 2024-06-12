const { exec } = require('child_process');
const dateFormat = require('dateformat');

// 设置仓库路径
const repoPath = './';

// 设置远程仓库的URL
const remoteUrl = 'https://github.com/ShineaSYR/testTime';

// 获取当前日期
const today = new Date();

// 获取120天前的日期
const daysAgo120 = new Date(today.getTime() - (120 * 24 * 60 * 60 * 1000));

// 创建提交历史
createCommitHistory(repoPath, daysAgo120, today, (error) => {
  if (error) {
    console.error(`Error creating commit history: ${error}`);
    return;
  }

  // 推送提交历史到远程仓库
  pushCommitsToRemote(repoPath, remoteUrl, (error) => {
    if (error) {
      console.error(`Error pushing commits to remote: ${error}`);
      return;
    }

    console.log('Commit history created and pushed to remote successfully!');
  });
});

function createCommitHistory(repoPath, startDate, endDate, callback) {
  let currentDate = startDate;
  const commitCount = 5; // 每天创建5个提交

  exec(`git -C ${repoPath} init`, (error) => {
    if (error) {
      callback(error);
      return;
    }

    createCommits(repoPath, currentDate, commitCount, (error) => {
      if (error) {
        callback(error);
        return;
      }

      currentDate = new Date(currentDate.getTime() + (24 * 60 * 60 * 1000)); // 移动到下一天
      if (currentDate <= endDate) {
        createCommitHistory(repoPath, currentDate, endDate, callback);
      } else {
        callback(null);
      }
    });
  });
}

function createCommits(repoPath, date, count, callback) {
  if (count === 0) {
    callback(null);
    return;
  }

  const formattedDate = dateFormat(date, 'yyyy-mm-dd');
  exec(`touch ${repoPath}/file_${formattedDate}.txt && git -C ${repoPath} add . && git -C ${repoPath} commit -m "Commit on ${formattedDate}"`, (error) => {
    if (error) {
      callback(error);
      return;
    }

    createCommits(repoPath, date, count - 1, callback);
  });
}

function pushCommitsToRemote(repoPath, remoteUrl, callback) {
  exec(`git -C ${repoPath} remote add origin ${remoteUrl} && git -C ${repoPath} push -u origin main`, (error, stdout, stderr) => {
    if (error) {
      callback(error);
      return;
    }

    callback(null);
  });
}