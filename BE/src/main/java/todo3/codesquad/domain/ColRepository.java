package todo3.codesquad.domain;

import org.springframework.data.jdbc.repository.query.Modifying;
import org.springframework.data.jdbc.repository.query.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface ColRepository extends CrudRepository<Col, Long> {

    @Query("select * from col where col.deleted = false")
    Optional<List<Col>> findColByNotDeleted();

    @Query("select id from col where col_name = :colName")
    Long findColIdByColName(@Param("colName") String colName);

    @Query("SELECT * FROM col WHERE col_name = :colName")
    Optional<Col> findColByColName(@Param("colName") String colName);

    @Query("select * from card where card.id = :cardId")
    Optional<Card> findCardByCardId(@Param("cardId") Long cardId);

    @Query("select * from col where col.id = (select col from card where card.id = :cardId)")
    Optional<Col> findColByCardId(@Param("cardId") Long cardId);

    @Query("select * from card where card.col = (select col from card where card.id = :cardId)")
    Optional<List<Card>> findCardsByCardId(@Param("cardId") Long cardId);

    @Query("select * from card where deleted = 0 and card.col = :colId order by card.row asc")
    Optional<List<Card>> findNotDeletedCardsByColId(@Param("colId") Long colId);

    @Query("select * from card where card.col = (select id from col where col_name = :colName)")
    Optional<List<Card>> findCardsByColName(@Param("colName") String colName);

    @Query("select col_name from col where col.id = (select col from card where card.id = :cardId)")
    Optional<String> findColNameByCardId(@Param("cardId") Long cardId);

    @Modifying
    @Query("update card set deleted = true, row = 0 where id = :cardId")
    boolean deleteCardByCardId(@Param("cardId") Long cardId);

    @Modifying
    @Query("update card set title = :title where id = :cardId")
    boolean updateCardTitleByCardId(@Param("cardId") Long cardId ,@Param("title") String title);

    @Modifying
    @Query("update card set contents = :contents where id = :cardId")
    boolean updateCardContentsByCardId(@Param("cardId") Long cardId ,@Param("contents") String contents);

    @Modifying
    @Query("update card set writer = :writer where id = :cardId")
    boolean updateCardWriterByCardId(@Param("cardId") Long cardId ,@Param("writer") String writer);
}
