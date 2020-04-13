package todo3.codesquad.domain;

import org.springframework.data.jdbc.repository.query.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.Optional;


public interface UserRepository extends CrudRepository<User,Long> {
    @Query("SELECT * FROM user WHERE user_id = :userId")
    Optional<User> findByUserId(@Param("userId") String userId);

    @Query("SELECT * FROM user WHERE user_id = \"unknownID\"")
    User findDefaultUser();
}
