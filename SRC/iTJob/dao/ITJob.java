package iTJob.dao;

import iTJob.dto.ITJobDto;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ITJob {
    void insertITJob(ITJobDto iTJobDto) throws SQLException;
    void insertITJobFromExcel(HashMap<Integer, ITJobDto> map) throws SQLException;
    boolean updateITJob(Map<String, Map<String, String>> map) throws SQLException;
    boolean deleteITJob(List<String> noList) throws SQLException;
    Map<Integer, ITJobDto> searchITJob(String[] dates, String[] status, String[] owner) throws SQLException;
}
